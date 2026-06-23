import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/chat_hub_service.dart';
import 'package:smart_guide/feature/chat/data/model/conversation_summary_update.dart';
import 'package:smart_guide/feature/chat/data/repo/chat_repo.dart';
import 'package:smart_guide/feature/chat/presentation/cubit/chat_inbox/chat_inbox_states.dart';

class ChatInboxCubit extends Cubit<ChatInboxState> {
  final ChatRepo chatRepo;

  StreamSubscription<ConversationSummaryUpdate>? _summarySubscription;
  StreamSubscription<Map<String, dynamic>>? _presenceSubscription;

  ChatInboxCubit({required this.chatRepo}) : super(const ChatInboxInitial()) {
    _connectHub();
  }

  // ─── Hub setup ────────────────────────────────────────────────────────────

  Future<void> _connectHub() async {
    await ChatHubService.instance.connect();

    _summarySubscription = ChatHubService.instance.summaryUpdates
        .listen(_onConversationSummaryUpdated);

    _presenceSubscription = ChatHubService.instance.presenceChanges
        .listen(_onUserPresenceChanged);
  }

  void _onConversationSummaryUpdated(ConversationSummaryUpdate update) {
    final current = state;
    if (current is! ChatInboxLoaded) return;

    final conversations = List.of(current.conversations);
    final idx = conversations.indexWhere((c) => c.id == update.conversationId);
    if (idx == -1) return;

    final updated = conversations[idx].copyWith(
      lastMessagePreview: update.lastMessagePreview,
      lastMessageSentAtUtc: update.lastMessageSentAtUtc,
      unreadCount: update.unreadCount,
    );

    conversations.removeAt(idx);
    conversations.insert(0, updated);

    emit(ChatInboxLoaded(conversations));
  }

  void _onUserPresenceChanged(Map<String, dynamic> data) {
    final current = state;
    if (current is! ChatInboxLoaded) return;

    final userId = data['userId'] as String? ?? '';
    final isOnline = data['isOnline'] as bool? ?? false;

    final conversations = current.conversations.map((c) {
      if (c.otherPartyUserId != userId) return c;
      return c.copyWith(isOtherPartyOnline: isOnline);
    }).toList();

    emit(ChatInboxLoaded(conversations));
  }

  // ─── Public API ───────────────────────────────────────────────────────────

  Future<void> loadInbox() async {
    emit(const ChatInboxLoading());
    final result = await chatRepo.getInbox();
    result.fold(
      (failure) => emit(ChatInboxFailure(failure.message)),
      (conversations) => emit(ChatInboxLoaded(conversations)),
    );
  }

  Future<void> startConversation({required String otherPartyUserId}) async {
    emit(const ChatStartingConversation());
    final result = await chatRepo.startConversation(
      otherPartyUserId: otherPartyUserId,
    );
    result.fold(
      (failure) => emit(ChatStartConversationFailure(failure.message)),
      (conversation) => emit(ChatConversationStarted(conversation)),
    );
  }

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  Future<void> close() async {
    await _summarySubscription?.cancel();
    await _presenceSubscription?.cancel();
    await ChatHubService.instance.disconnect();
    return super.close();
  }
}
