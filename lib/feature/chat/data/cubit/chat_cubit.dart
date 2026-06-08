import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/chat/data/model/feature/chat/data/model/chat_conversation_model.dart';
import 'chat_state.dart';
import '../model/chat_message.dart';
import '../model/conversation_model.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final Dio dio = Dio();

  List<MessageModel> messages = [];

  final String baseUrl =
      "https://smartguide.runasp.net/api/chat/conversations";

  /// CREATE CONVERSATION
  Future<void> createConversation(String guideId) async {
    try {
      emit(CreateConversationLoading());

      final token = await SecureStorageHelper.instance.getAccessToken();

      final response = await dio.post(
        baseUrl,
        data: {"otherPartyUserId": guideId},
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      final conversation =
          ConversationModel.fromJson(response.data);

      emit(CreateConversationSuccess(conversation));
    } catch (e) {
      emit(CreateConversationError(e.toString()));
    }
  }

  /// GET MESSAGES
  Future<void> getMessages(String conversationId) async {
    try {
      emit(GetMessagesLoading());

      final token = await SecureStorageHelper.instance.getAccessToken();

      final response = await dio.get(
        "$baseUrl/$conversationId/messages",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      messages = (response.data['items'] as List)
          .map((e) => MessageModel.fromJson(e))
          .toList();

      emit(GetMessagesSuccess(List.from(messages)));
    } catch (e) {
      emit(GetMessagesError(e.toString()));
    }
  }

  /// SEND MESSAGE
  Future<void> sendMessage(String conversationId, String text) async {
    try {
      final token = await SecureStorageHelper.instance.getAccessToken();

      final response = await dio.post(
        "$baseUrl/$conversationId/messages",
        data: {"content": text},
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      final newMsg = MessageModel.fromJson(response.data);

      messages.insert(0, newMsg);

      emit(GetMessagesSuccess(List.from(messages)));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  /// MARK AS READ 👇
  Future<void> markAsRead(String conversationId) async {
    try {
      final token = await SecureStorageHelper.instance.getAccessToken();

      await dio.post(
        "$baseUrl/$conversationId/read",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }



  List<ChatConversationModel> conversations = [];

Future<void> getConversations() async {
  try {
    emit(GetConversationsLoading());

    final token = await SecureStorageHelper.instance.getAccessToken();

    final response = await dio.get(
      "https://smartguide.runasp.net/api/chat/conversations?page=1&pageSize=30",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    conversations = (response.data['items'] as List)
        .map((e) => ChatConversationModel.fromJson(e))
        .toList();

    emit(GetConversationsSuccess(List.from(conversations)));
  } catch (e) {
    emit(ChatError(e.toString()));
  }
}
}