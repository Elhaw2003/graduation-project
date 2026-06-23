import 'package:smart_guide/feature/chat/data/model/chat_message_model.dart';
import 'package:smart_guide/feature/chat/data/model/conversation_model.dart';

abstract class ChatRoomState {
  const ChatRoomState();
}

class ChatRoomInitial extends ChatRoomState {
  const ChatRoomInitial();
}

class ChatRoomLoading extends ChatRoomState {
  const ChatRoomLoading();
}

class ChatRoomLoaded extends ChatRoomState {
  final ConversationModel conversation;
  final List<ChatMessageModel> messages;
  final String currentUserId;
  final bool isSending;
  final bool isLoadingMore;
  final bool isOtherPartyOnline;
  final ChatMessageModel? editingMessage;
  final String? snackBarMessage;

  const ChatRoomLoaded({
    required this.conversation,
    required this.messages,
    required this.currentUserId,
    this.isSending = false,
    this.isLoadingMore = false,
    this.isOtherPartyOnline = false,
    this.editingMessage,
    this.snackBarMessage,
  });

  ChatRoomLoaded copyWith({
    ConversationModel? conversation,
    List<ChatMessageModel>? messages,
    bool? isSending,
    bool? isLoadingMore,
    bool? isOtherPartyOnline,
    ChatMessageModel? editingMessage,
    bool clearEditing = false,
    String? snackBarMessage,
    bool clearSnackBar = false,
  }) {
    return ChatRoomLoaded(
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      currentUserId: currentUserId,
      isSending: isSending ?? this.isSending,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isOtherPartyOnline: isOtherPartyOnline ?? this.isOtherPartyOnline,
      editingMessage: clearEditing
          ? null
          : (editingMessage ?? this.editingMessage),
      snackBarMessage: clearSnackBar
          ? null
          : (snackBarMessage ?? this.snackBarMessage),
    );
  }
}

class ChatRoomFailure extends ChatRoomState {
  final String message;
  const ChatRoomFailure(this.message);
}
