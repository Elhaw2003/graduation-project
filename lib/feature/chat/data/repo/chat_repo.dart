import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/feature/chat/data/model/chat_message.dart';
import 'package:smart_guide/feature/chat/data/model/conversation_model.dart';

abstract class ChatRepo {
  Future<Either<Failure, List<ConversationModel>>> getInbox({
    int page = 1,
    int pageSize = 30,
  });

  Future<Either<Failure, ConversationModel>> startConversation({
    required String otherPartyUserId,
  });

  Future<Either<Failure, ConversationModel>> getConversation({
    required String conversationId,
  });

  Future<Either<Failure, List<ChatMessageModel>>> getMessages({
    required String conversationId,
    int pageSize = 30,
    String? beforeSentAtUtc,
  });

  Future<Either<Failure, ChatMessageModel>> sendMessage({
    required String conversationId,
    required String content,
  });

  Future<Either<Failure, ChatMessageModel>> editMessage({
    required String messageId,
    required String content,
  });

  Future<Either<Failure, void>> deleteMessage({required String messageId});

  Future<Either<Failure, void>> markAsRead({required String conversationId});

  Future<Either<Failure, void>> blockConversation({
    required String conversationId,
  });

  Future<Either<Failure, void>> unblockConversation({
    required String conversationId,
  });
}
