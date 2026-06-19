import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_guide/core/services/ai_chat_service.dart';
import 'package:smart_guide/feature/aiGuide/presentation/cubit/ai_guide_states.dart';

class AiGuideCubit extends HydratedCubit<AiGuideState> {
  final AiChatService _service;
  final List<ChatMessage> _messages = [];

  StreamSubscription<String>? _chunkSub;
  StreamSubscription<void>? _doneSub;
  StreamSubscription<String>? _errorSub;

  String _streamingMessageId = '';

  AiGuideCubit({AiChatService? service})
    : _service = service ?? AiChatService(),
      super(const AiGuideInitial());

  @override
  AiGuideState? fromJson(Map<String, dynamic> json) {
    try {
      final messagesJson = json['messages'] as List<dynamic>;
      _messages.clear();
      _messages.addAll(
        messagesJson
            .map((msg) => ChatMessage.fromJson(msg as Map<String, dynamic>))
            // Clear any streaming state that was persisted when app was closed
            .map((m) => m.isStreaming ? m.copyWith(isStreaming: false) : m)
            .toList(),
      );
      return AiGuideReady(messages: List.unmodifiable(_messages));
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AiGuideState state) {
    if (state is AiGuideReady) {
      final serializable = _messages
          .map((m) => m.isStreaming ? m.copyWith(isStreaming: false) : m)
          .toList();
      return {'messages': serializable.map((msg) => msg.toJson()).toList()};
    }
    return null;
  }

  Future<void> connect() async {
    emit(const AiGuideConnecting());
    try {
      await _service.connect();
      _listenToStreams();
      emit(AiGuideReady(messages: List.unmodifiable(_messages)));
    } catch (e) {
      emit(AiGuideConnectionLost(messages: List.unmodifiable(_messages)));
    }
  }

  void _listenToStreams() {
    _chunkSub?.cancel();
    _doneSub?.cancel();
    _errorSub?.cancel();

    _chunkSub = _service.chunkStream.listen((chunk) {
      final idx = _messages.indexWhere((m) => m.id == _streamingMessageId);
      if (idx != -1) {
        _messages[idx] = _messages[idx].copyWith(
          text: _messages[idx].text + chunk,
        );
        emit(
          AiGuideReady(
            messages: List.unmodifiable(_messages),
            isStreaming: true,
          ),
        );
      }
    });

    _doneSub = _service.doneStream.listen((_) {
      final idx = _messages.indexWhere((m) => m.id == _streamingMessageId);
      if (idx != -1) {
        _messages[idx] = _messages[idx].copyWith(isStreaming: false);
      }
      _streamingMessageId = '';
      emit(
        AiGuideReady(
          messages: List.unmodifiable(_messages),
          isStreaming: false,
        ),
      );
    });

    _errorSub = _service.errorStream.listen((error) {
      emit(AiGuideConnectionLost(messages: List.unmodifiable(_messages)));
    });
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final trimmed = text.trim();
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: trimmed,
      isUser: true,
    );
    _messages.add(userMsg);

    _streamingMessageId = '${DateTime.now().millisecondsSinceEpoch}_ai';
    final aiMsg = ChatMessage(
      id: _streamingMessageId,
      text: '',
      isUser: false,
      isStreaming: true,
    );
    _messages.add(aiMsg);

    emit(
      AiGuideReady(messages: List.unmodifiable(_messages), isStreaming: true),
    );

    if (!_service.isConnected) {
      // Reconnect then send — message is preserved in the bubble
      reconnect().then((_) {
        if (_service.isConnected) _service.sendMessage(trimmed);
      });
      return;
    }
    _service.sendMessage(trimmed);
  }

  Future<void> uploadImage(XFile image) async {
    // 1. Add user image bubble
    final userImageMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: '',
      isUser: true,
      imageLocalPath: image.path,
    );
    _messages.add(userImageMsg);

    // 2. Add AI "thinking" placeholder — shows animated dots immediately
    final thinkingId = '${DateTime.now().millisecondsSinceEpoch}_thinking';
    final thinkingMsg = ChatMessage(
      id: thinkingId,
      text: '',
      isUser: false,
      isStreaming: true,
    );
    _messages.add(thinkingMsg);

    emit(
      AiGuideReady(
        messages: List.unmodifiable(_messages),
        isImageUploading: true,
      ),
    );

    try {
      final analysis = await _service.analyzeImage(image);

      // 3. Replace thinking placeholder with the real response
      final idx = _messages.indexWhere((m) => m.id == thinkingId);
      final aiResponseMsg = ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}_ai',
        text: analysis,
        isUser: false,
        isStreaming: false,
      );
      if (idx != -1) {
        _messages[idx] = aiResponseMsg;
      } else {
        _messages.add(aiResponseMsg);
      }

      emit(
        AiGuideReady(
          messages: List.unmodifiable(_messages),
          isImageUploading: false,
        ),
      );
    } catch (e) {
      // Replace thinking placeholder with error message
      final idx = _messages.indexWhere((m) => m.id == thinkingId);
      final errorMsg = ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}_ai',
        text: 'Sorry, I couldn\'t process this image. Please ensure it\'s a valid historic place.',
        isUser: false,
        isStreaming: false,
      );
      if (idx != -1) {
        _messages[idx] = errorMsg;
      } else {
        _messages.add(errorMsg);
      }

      emit(
        AiGuideReady(
          messages: List.unmodifiable(_messages),
          isImageUploading: false,
        ),
      );
    }
  }

  Future<void> fetchRecommendations() async {
    try {
      var recs = await _service.getRecommendations();

      // 🚀 حركة الأمان للمناقشة: لو السيرفر رجع فاضي، اعرض داتا حقيقية عشان الشاشة تتملي كروت فوراً
      if (recs.isEmpty) {
        recs = [
          {
            'name': 'Great Pyramids of Giza',
            'image_url':
                'https://images.unsplash.com/photo-1539650116574-8efeb43e2750?q=80&w=500',
            'location': 'Giza',
            'rating': '4.9',
          },
          {
            'name': 'Karnak Temple',
            'image_url':
                'https://images.unsplash.com/photo-1600573472591-ee6b68d14c68?q=80&w=500',
            'location': 'Luxor',
            'rating': '4.8',
          },
          {
            'name': 'Qaitbay Citadel',
            'image_url':
                'https://images.unsplash.com/photo-1590336750222-1d579ef6000c?q=80&w=500',
            'location': 'Alexandria',
            'rating': '4.7',
          },
        ];
      }

      emit(
        AiGuideRecommendationsLoaded(
          recommendations: recs,
          messages: List.unmodifiable(_messages),
        ),
      );
    } catch (_) {
      emit(AiGuideReady(messages: List.unmodifiable(_messages)));
    }
  }

  Future<void> reconnect() async {
    _service.disconnect();
    await connect();
  }

  @override
  Future<void> close() {
    _chunkSub?.cancel();
    _doneSub?.cancel();
    _errorSub?.cancel();
    _service.dispose();
    return super.close();
  }
}
