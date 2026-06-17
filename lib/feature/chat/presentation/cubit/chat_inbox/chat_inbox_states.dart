import 'package:smart_guide/feature/chat/data/model/conversation_model.dart';

abstract class ChatInboxState {
  const ChatInboxState();
}

class ChatInboxInitial extends ChatInboxState {
  const ChatInboxInitial();
}

class ChatInboxLoading extends ChatInboxState {
  const ChatInboxLoading();
}

class ChatInboxLoaded extends ChatInboxState {
  final List<ConversationModel> conversations;
  const ChatInboxLoaded(this.conversations);
}

class ChatInboxFailure extends ChatInboxState {
  final String message;
  const ChatInboxFailure(this.message);
}

class ChatStartingConversation extends ChatInboxState {
  const ChatStartingConversation();
}

class ChatConversationStarted extends ChatInboxState {
  final ConversationModel conversation;
  const ChatConversationStarted(this.conversation);
}

class ChatStartConversationFailure extends ChatInboxState {
  final String message;
  const ChatStartConversationFailure(this.message);
}
