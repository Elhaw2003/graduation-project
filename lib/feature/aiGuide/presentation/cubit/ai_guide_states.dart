import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String text;
  final bool isUser;
  final bool isStreaming;
  final String? imageLocalPath;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    this.isStreaming = false,
    this.imageLocalPath,
  });

  // 🚀 تم إضافة دالة الـ FromJson لتجفيف واسترجاع البيانات من التخزين المحلي لـ Hydrated
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      isStreaming: json['isStreaming'] as bool? ?? false,
      imageLocalPath: json['imageLocalPath'] as String?,
    );
  }

  // 🚀 تم إضافة دالة الـ ToJson لتحويل العناصر لخريطة قابلة للحفظ التلقائي
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'isStreaming': isStreaming,
      'imageLocalPath': imageLocalPath,
    };
  }

  ChatMessage copyWith({String? text, bool? isStreaming}) {
    return ChatMessage(
      id: id,
      text: text ?? this.text,
      isUser: isUser,
      isStreaming: isStreaming ?? this.isStreaming,
      imageLocalPath: imageLocalPath,
    );
  }

  @override
  List<Object?> get props => [id, text, isUser, isStreaming, imageLocalPath];
}

abstract class AiGuideState extends Equatable {
  const AiGuideState();

  @override
  List<Object?> get props => [];
}

class AiGuideInitial extends AiGuideState {
  const AiGuideInitial();
}

class AiGuideConnecting extends AiGuideState {
  const AiGuideConnecting();
}

class AiGuideReady extends AiGuideState {
  final List<ChatMessage> messages;
  final bool isStreaming;
  final bool isImageUploading;

  const AiGuideReady({
    required this.messages,
    this.isStreaming = false,
    this.isImageUploading = false,
  });

  AiGuideReady copyWith({
    List<ChatMessage>? messages,
    bool? isStreaming,
    bool? isImageUploading,
  }) {
    return AiGuideReady(
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
      isImageUploading: isImageUploading ?? this.isImageUploading,
    );
  }

  @override
  List<Object?> get props => [messages, isStreaming, isImageUploading];
}

class AiGuideConnectionLost extends AiGuideState {
  final List<ChatMessage> messages;

  const AiGuideConnectionLost({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class AiGuideRecommendationsLoaded extends AiGuideState {
  final List<Map<String, dynamic>> recommendations;
  final List<ChatMessage> messages;

  const AiGuideRecommendationsLoaded({
    required this.recommendations,
    required this.messages,
  });

  @override
  List<Object?> get props => [recommendations, messages];
}

class AiGuideError extends AiGuideState {
  final String errorMessage;
  final List<ChatMessage> messages;

  const AiGuideError({required this.errorMessage, required this.messages});

  @override
  List<Object?> get props => [errorMessage, messages];
}
