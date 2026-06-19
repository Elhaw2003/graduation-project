import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/chat/data/model/chat_message_model.dart';
import 'package:smart_guide/feature/chat/data/repo/chat_repo.dart';
import 'package:smart_guide/feature/chat/presentation/cubit/chat_room/chat_room_states.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final ChatRepo chatRepo;

  ChatRoomCubit({required this.chatRepo}) : super(const ChatRoomInitial());

  Future<void> loadRoom({required String conversationId}) async {
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
  }

  Future<void> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    final loaded = _currentLoaded;
    if (loaded == null) return;

    // Optimistic: show message immediately with isSending=true
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
    emit(loaded.copyWith(
      messages: [optimistic, ...loaded.messages],
      isSending: true,
    ));

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
        final updated =
            current.messages.map((m) => m.id == tempId ? message : m).toList();
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

    result.fold((_) => emit(loaded.copyWith(clearEditing: true)), (updated) {
      final msgs = loaded.messages
          .map((m) => m.id == updated.id ? updated : m)
          .toList();
      emit(
        loaded.copyWith(
          messages: msgs,
          clearEditing: true,
          snackBarMessage: 'Message edited successfully',
        ),
      );
    });
  }

  Future<void> deleteMessage({required String messageId}) async {
    final loaded = _currentLoaded;
    if (loaded == null) return;

    // Optimistic removal
    final optimistic = loaded.messages.where((m) => m.id != messageId).toList();
    emit(loaded.copyWith(messages: optimistic));

    final result = await chatRepo.deleteMessage(messageId: messageId);
    result.fold(
      (_) {
        // Revert on failure by reloading
        loadRoom(conversationId: loaded.conversation.id);
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
          conversation: loaded.conversation.copyWith(isMessagingBlocked: false),
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

  ChatRoomLoaded? get _currentLoaded {
    final s = state;
    return s is ChatRoomLoaded ? s : null;
  }
}
