import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/chat/data/repo/chat_repo.dart';
import 'package:smart_guide/feature/chat/presentation/cubit/chat_inbox/chat_inbox_states.dart';

class ChatInboxCubit extends Cubit<ChatInboxState> {
  final ChatRepo chatRepo;

  ChatInboxCubit({required this.chatRepo}) : super(const ChatInboxInitial());

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
}
