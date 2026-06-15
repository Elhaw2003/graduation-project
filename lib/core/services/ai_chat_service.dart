import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class AiChatService {
  static const String _wsUrl =
      'wss://rafeeq-ai-dev-production.up.railway.app/chat/ws';
  static const String _imageApiUrl =
      'https://image-api-9dg4.onrender.com/analyze';
  static const String _recommendationApiUrl =
      'https://recommendatio-api.onrender.com/recommend';

  WebSocket? _socket;
  StreamSubscription? _subscription;

  final _chunkController = StreamController<String>.broadcast();
  final _doneController = StreamController<void>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  Stream<String> get chunkStream => _chunkController.stream;
  Stream<void> get doneStream => _doneController.stream;
  Stream<String> get errorStream => _errorController.stream;

  bool get isConnected =>
      _socket != null && _socket!.readyState == WebSocket.open;

  Future<void> connect() async {
    await _subscription?.cancel();
    try {
      _socket = await WebSocket.connect(
        _wsUrl,
      ).timeout(const Duration(seconds: 10));
      _subscription = _socket!.listen(
        (data) {
          try {
            final decoded = jsonDecode(data as String) as Map<String, dynamic>;
            final type = decoded['type'] as String?;

            switch (type) {
              case 'chunk':
                final content = decoded['content'] as String? ?? '';
                if (!_chunkController.isClosed) _chunkController.add(content);
                break;
              case 'done':
                if (!_doneController.isClosed) _doneController.add(null);
                break;
              case 'ping':
                _socket?.add(jsonEncode({'type': 'pong'}));
                break;
            }
          } catch (_) {}
        },
        onError: (e) {
          if (!_errorController.isClosed) _errorController.add(e.toString());
        },
        onDone: () {
          _socket = null;
        },
      );
    } catch (e) {
      if (!_errorController.isClosed) _errorController.add(e.toString());
      rethrow;
    }
  }

  // 🚀 الحل الجذري للنص: تم تعديل الـ Format ليتطابق مع السيرفر تماماً
  void sendMessage(String content) {
    if (!isConnected) return;
    _socket!.add(
      jsonEncode({
        "question": content.trim(),
        "session_id": "smart-guide-tourist-session",
      }),
    );
  }

  // 🚀 الحل الجذري للصورة: تم تأمين إرسال الـ Multipart وتجربة الـ Keys المتوقعة
  Future<String> analyzeImage(XFile image) async {
    final dio = Dio();
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path, filename: image.name),
    });

    final response = await dio.post(
      _imageApiUrl,
      data: formData,
      options: Options(
        headers: {'Accept': 'application/json'},
        validateStatus: (status) => true, // عشان نشوف الـ response حتى لو ضرب
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return (data['result'] ??
                data['description'] ??
                data['text'] ??
                data['status'] ??
                data.toString())
            .toString();
      }
      return data.toString();
    }
    throw Exception('Failed: ${response.statusCode}');
  }

  Future<List<Map<String, dynamic>>> getRecommendations() async {
    final dio = Dio();
    try {
      final response = await dio.get(_recommendationApiUrl);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List)
          return data.whereType<Map<String, dynamic>>().toList();
        if (data is Map<String, dynamic>) {
          final inner =
              data['data'] ??
              data['results'] ??
              data['places'] ??
              data['message'];
          if (inner is List)
            return inner.whereType<Map<String, dynamic>>().toList();
        }
      }
    } catch (_) {}
    return [];
  }

  void disconnect() {
    _subscription?.cancel();
    _socket?.close();
    _socket = null;
  }

  void dispose() {
    disconnect();
    _chunkController.close();
    _doneController.close();
    _errorController.close();
  }
}
