import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/services/chat_hub_service.dart';
import 'package:smart_guide/feature/chat/data/model/chat_message_model.dart';
import 'package:smart_guide/feature/chat/data/repo/chat_repo.dart';
import 'package:smart_guide/feature/chat/presentation/cubit/chat_room/chat_room_states.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final ChatRepo chatRepo;

  StreamSubscription<Map<String, dynamic>>? _newMessageSub;
  StreamSubscription<Map<String, dynamic>>? _editedSub;
  StreamSubscription<Map<String, dynamic>>? _deletedSub;
  StreamSubscription<Map<String, dynamic>>? _statusSub;
  StreamSubscription<Map<String, dynamic>>? _readReceiptSub;
  StreamSubscription<Map<String, dynamic>>? _presenceSub;

  String? _conversationId;

  ChatRoomCubit({required this.chatRepo}) : super(const ChatRoomInitial());

  // ─── Load ─────────────────────────────────────────────────────────────────

  Future<void> loadRoom({required String conversationId}) async {
    _conversationId = conversationId;
    emit(const ChatRoomLoading());

    final userId = await SecureStorageHelper.instance.getUserId();

    final convResult = await chatRepo.getConversation(
      conversationId: conversationId,
    );

    if (convResult.isLeft()) {
      final failure = convResult.fold((l) => l, (_) => null)!;
      emit(ChatRoomFailure(failure.message));
      return;
    }

    final conversation = convResult.fold((_) => null, (r) => r)!;

    final msgsResult = await chatRepo.getMessages(
      conversationId: conversationId,
    );
    final messages = msgsResult.fold<List<ChatMessageModel>>(
      (_) => <ChatMessageModel>[],
      (r) => r,
    );

    // Mark as read concurrently — don't block UI.
    chatRepo.markAsRead(conversationId: conversationId);

    emit(
      ChatRoomLoaded(
        conversation: conversation,
        messages: messages,
        currentUserId: userId ?? '',
      ),
    );

    _subscribeToHub(conversationId);
  }

  // ─── SignalR subscriptions ─────────────────────────────────────────────────

  void _subscribeToHub(String conversationId) {
    _cancelHubSubs();

    // ReceiveChatMessage — new message from the other party
    _newMessageSub = ChatHubService.instance.newMessages.listen((data) {
      final msgConvId = data['conversationId'] as String? ?? '';
      if (msgConvId != conversationId) return;

      final loaded = _currentLoaded;
      if (loaded == null) return;

      final msg = ChatMessageModel.fromJson(data);

      // Ignore if we already have this message (could be our own confirmed msg)
      if (loaded.messages.any((m) => m.id == msg.id)) return;

      // Ignore if it's our own message — handled optimistically via sendMessage
      if (msg.senderUserId == loaded.currentUserId) return;

      emit(loaded.copyWith(messages: [msg, ...loaded.messages]));

      // Mark the new incoming message as read immediately
      chatRepo.markAsRead(conversationId: conversationId);
    });

    // ChatMessageEdited — someone edited a message
    _editedSub = ChatHubService.instance.messageEdits.listen((data) {
      final loaded = _currentLoaded;
      if (loaded == null) return;

      final msgId = _extractId(data);
      if (msgId.isEmpty) return;

      final editedAtStr = data['editedAtUtc'] as String?;

      final msgs = loaded.messages.map((m) {
        if (m.id != msgId) return m;
        return m.copyWith(
          content: data['content'] as String? ?? m.content,
          displayContent: data['displayContent'] as String?,
          isEdited: true,
          editedAtUtc: editedAtStr != null ? _parseUtc(editedAtStr) : m.editedAtUtc,
        );
      }).toList();

      emit(loaded.copyWith(messages: msgs));
    });

    // ChatMessageDeleted — someone deleted a message
    _deletedSub = ChatHubService.instance.messageDeletes.listen((data) {
      final loaded = _currentLoaded;
      if (loaded == null) return;

      final msgId = _extractId(data);
      if (msgId.isEmpty) return;

      final msgs = loaded.messages.map((m) {
        if (m.id != msgId) return m;
        return m.copyWith(isDeleted: true);
      }).toList();

      emit(loaded.copyWith(messages: msgs));
    });

    // ChatMessageStatusUpdated — status changed: Sent(0) → Delivered(1) → Seen(2)
    _statusSub = ChatHubService.instance.statusUpdates.listen((data) {
      final loaded = _currentLoaded;
      if (loaded == null) return;

      final msgId = data['messageId'] as String? ?? _extractId(data);
      if (msgId.isEmpty) return;

      final newStatus = data['status'] as int? ?? 0;
      final seenAtStr = data['seenAtUtc'] as String?;

      final msgs = loaded.messages.map((m) {
        if (m.id != msgId) return m;
        return m.copyWith(
          status: newStatus,
          seenAtUtc: seenAtStr != null ? _parseUtc(seenAtStr) : m.seenAtUtc,
        );
      }).toList();

      emit(loaded.copyWith(messages: msgs));
    });

    // ConversationReadReceipt — other party opened and read the conversation
    _readReceiptSub = ChatHubService.instance.readReceipts.listen((data) {
      final convId = data['conversationId'] as String? ?? '';
      if (convId != conversationId) return;

      final loaded = _currentLoaded;
      if (loaded == null) return;

      final seenAtStr = data['seenAtUtc'] as String?;
      final seenAt = seenAtStr != null ? _parseUtc(seenAtStr) : DateTime.now().toUtc();

      // Mark all MY outgoing messages that aren't already Seen
      final msgs = loaded.messages.map((m) {
        if (m.senderUserId != loaded.currentUserId) return m;
        if (m.status == 2) return m;
        return m.copyWith(status: 2, seenAtUtc: seenAt);
      }).toList();

      emit(loaded.copyWith(messages: msgs));
    });

    // UserPresenceChanged — online/offline indicator update
    _presenceSub = ChatHubService.instance.presenceChanges.listen((data) {
      final loaded = _currentLoaded;
      if (loaded == null) return;

      final userId = data['userId'] as String? ?? '';
      if (userId != loaded.conversation.otherPartyUserId) return;

      final isOnline = data['isOnline'] as bool? ?? false;
      emit(loaded.copyWith(isOtherPartyOnline: isOnline));
    });
  }

  void _cancelHubSubs() {
    _newMessageSub?.cancel();
    _editedSub?.cancel();
    _deletedSub?.cancel();
    _statusSub?.cancel();
    _readReceiptSub?.cancel();
    _presenceSub?.cancel();
  }

  // ─── Message actions ───────────────────────────────────────────────────────

  Future<void> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    final loaded = _currentLoaded;
    if (loaded == null) return;

    // Optimistic: show message immediately with isSending=true, status=0 (Sent)
    final tempId = '_sending_${DateTime.now().millisecondsSinceEpoch}';
    final optimistic = ChatMessageModel(
      id: tempId,
      conversationId: conversationId,
      senderUserId: loaded.currentUserId,
      content: content,
      sentAtUtc: DateTime.now().toUtc(),
      status: 0,
      isEdited: false,
      isDeleted: false,
      isSending: true,
    );
    emit(
      loaded.copyWith(
        messages: [optimistic, ...loaded.messages],
        isSending: true,
      ),
    );

    final result = await chatRepo.sendMessage(
      conversationId: conversationId,
      content: content,
    );

    final current = _currentLoaded;
    if (current == null) return;

    result.fold(
      (_) {
        final reverted =
            current.messages.where((m) => m.id != tempId).toList();
        emit(current.copyWith(messages: reverted, isSending: false));
      },
      (message) {
        final updated = current.messages
            .map((m) => m.id == tempId ? message : m)
            .toList();
        emit(current.copyWith(messages: updated, isSending: false));
      },
    );
  }

  void startEditing(ChatMessageModel message) {
    final loaded = _currentLoaded;
    if (loaded == null) return;
    emit(loaded.copyWith(editingMessage: message));
  }

  void cancelEditing() {
    final loaded = _currentLoaded;
    if (loaded == null) return;
    emit(loaded.copyWith(clearEditing: true));
  }

  Future<void> submitEdit({
    required String messageId,
    required String content,
  }) async {
    final loaded = _currentLoaded;
    if (loaded == null) return;

    final result = await chatRepo.editMessage(
      messageId: messageId,
      content: content,
    );

    result.fold(
      (_) => emit(loaded.copyWith(clearEditing: true)),
      (updated) {
        final msgs =
            loaded.messages.map((m) => m.id == updated.id ? updated : m).toList();
        emit(
          loaded.copyWith(
            messages: msgs,
            clearEditing: true,
            snackBarMessage: 'Message edited successfully',
          ),
        );
      },
    );
  }

  Future<void> deleteMessage({required String messageId}) async {
    final loaded = _currentLoaded;
    if (loaded == null) return;

    // Optimistic removal
    final optimistic =
        loaded.messages.where((m) => m.id != messageId).toList();
    emit(loaded.copyWith(messages: optimistic));

    final result = await chatRepo.deleteMessage(messageId: messageId);
    result.fold(
      (_) {
        // Revert on failure by reloading
        if (_conversationId != null) {
          loadRoom(conversationId: _conversationId!);
        }
      },
      (_) {
        final current = _currentLoaded;
        if (current != null) {
          emit(current.copyWith(snackBarMessage: 'Message deleted'));
        }
      },
    );
  }

  Future<void> blockConversation({required String conversationId}) async {
    final loaded = _currentLoaded;
    if (loaded == null) return;

    final result = await chatRepo.blockConversation(
      conversationId: conversationId,
    );
    result.fold((_) {}, (_) {
      emit(
        loaded.copyWith(
          conversation: loaded.conversation.copyWith(isMessagingBlocked: true),
          snackBarMessage: 'User blocked',
        ),
      );
    });
  }

  Future<void> unblockConversation({required String conversationId}) async {
    final loaded = _currentLoaded;
    if (loaded == null) return;

    final result = await chatRepo.unblockConversation(
      conversationId: conversationId,
    );
    result.fold((_) {}, (_) {
      emit(
        loaded.copyWith(
          conversation:
              loaded.conversation.copyWith(isMessagingBlocked: false),
          snackBarMessage: 'User unblocked',
        ),
      );
    });
  }

  void clearSnackBar() {
    final loaded = _currentLoaded;
    if (loaded == null) return;
    emit(loaded.copyWith(clearSnackBar: true));
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  ChatRoomLoaded? get _currentLoaded {
    final s = state;
    return s is ChatRoomLoaded ? s : null;
  }

  String _extractId(Map<String, dynamic> data) =>
      data['id'] as String? ?? data['messageId'] as String? ?? '';

  static DateTime _parseUtc(String s) {
    final fixed = s.replaceFirstMapped(
      RegExp(r'(\.\d{6})\d+'),
      (m) => m.group(1)!,
    );
    final dt = DateTime.tryParse(fixed);
    if (dt == null) return DateTime.now().toUtc();
    return dt.isUtc
        ? dt
        : DateTime.utc(
            dt.year, dt.month, dt.day,
            dt.hour, dt.minute, dt.second, dt.millisecond,
          );
  }

  @override
  Future<void> close() async {
    _cancelHubSubs();
    return super.close();
  }
}
