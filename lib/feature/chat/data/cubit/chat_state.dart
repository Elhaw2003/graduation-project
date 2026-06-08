import 'package:smart_guide/feature/chat/data/model/feature/chat/data/model/chat_conversation_model.dart';

import '../model/chat_message.dart';
import '../model/conversation_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

/// CREATE
class CreateConversationLoading extends ChatState {}

class CreateConversationSuccess extends ChatState {
  final ConversationModel conversation;

  CreateConversationSuccess(this.conversation);
}

class CreateConversationError extends ChatState {
  final String message;

  CreateConversationError(this.message);
}

/// MESSAGES
class GetMessagesLoading extends ChatState {}

class GetMessagesSuccess extends ChatState {
  final List<MessageModel> messages;

  GetMessagesSuccess(this.messages);
}

class GetMessagesError extends ChatState {
  final String message;

  GetMessagesError(this.message);
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}
class GetConversationsLoading extends ChatState {}

class GetConversationsSuccess extends ChatState {
  final List<ChatConversationModel> conversations;

  GetConversationsSuccess(this.conversations);
}