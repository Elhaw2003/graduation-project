import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/feature/chat/data/model/chat_message_model.dart';
import 'package:smart_guide/feature/chat/data/model/conversation_model.dart';
import 'package:smart_guide/feature/chat/data/repo/chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  final ApiConsumer apiConsumer;

  ChatRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, List<ConversationModel>>> getInbox({
    int page = 1,
    int pageSize = 30,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoint.chatConversations(page: page, pageSize: pageSize),
      );
      final items = (response['items'] as List? ?? [])
          .map((e) => ConversationModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (_) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, ConversationModel>> startConversation({
    required String otherPartyUserId,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoint.chatStartConversation,
        data: {'otherPartyUserId': otherPartyUserId},
      );
      return Right(
        ConversationModel.fromJson(response as Map<String, dynamic>),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (_) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, ConversationModel>> getConversation({
    required String conversationId,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoint.chatGetConversation(conversationId: conversationId),
      );
      return Right(
        ConversationModel.fromJson(response as Map<String, dynamic>),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (_) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessageModel>>> getMessages({
    required String conversationId,
    int pageSize = 30,
    String? beforeSentAtUtc,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoint.chatMessages(
          conversationId: conversationId,
          pageSize: pageSize,
          beforeSentAtUtc: beforeSentAtUtc,
        ),
      );
      final items =
          (response['items'] as List? ?? [])
              .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
              .toList()
            ..sort((a, b) => b.sentAtUtc.compareTo(a.sentAtUtc));
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (_) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, ChatMessageModel>> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoint.chatSendMessage(conversationId: conversationId),
        data: {'content': content},
      );
      return Right(ChatMessageModel.fromJson(response as Map<String, dynamic>));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (_) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, ChatMessageModel>> editMessage({
    required String messageId,
    required String content,
  }) async {
    try {
      final response = await apiConsumer.patch(
        EndPoint.chatEditMessage(messageId: messageId),
        data: {'content': content},
      );
      return Right(ChatMessageModel.fromJson(response as Map<String, dynamic>));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (_) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage({
    required String messageId,
  }) async {
    try {
      await apiConsumer.delete(
        EndPoint.chatDeleteMessage(messageId: messageId),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (_) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead({
    required String conversationId,
  }) async {
    try {
      await apiConsumer.post(
        EndPoint.chatMarkAsRead(conversationId: conversationId),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (_) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, void>> blockConversation({
    required String conversationId,
  }) async {
    try {
      await apiConsumer.post(
        EndPoint.chatBlockConversation(conversationId: conversationId),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (_) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, void>> unblockConversation({
    required String conversationId,
  }) async {
    try {
      await apiConsumer.post(
        EndPoint.chatUnblockConversation(conversationId: conversationId),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (_) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }
}
