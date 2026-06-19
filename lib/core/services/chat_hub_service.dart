import 'dart:async';

import 'package:signalr_netcore/signalr_client.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/chat/data/model/conversation_summary_update.dart';

/// Manages the SignalR hub connection for real-time chat events.
///
/// Usage:
///   await ChatHubService.instance.connect();
///   ChatHubService.instance.summaryUpdates.listen(...)
///   await ChatHubService.instance.disconnect();
class ChatHubService {
  ChatHubService._();
  static final ChatHubService instance = ChatHubService._();

  HubConnection? _connection;

  final _summaryController =
      StreamController<ConversationSummaryUpdate>.broadcast();

  /// Stream that emits every time `ConversationSummaryUpdated` is received.
  Stream<ConversationSummaryUpdate> get summaryUpdates =>
      _summaryController.stream;

  bool get isConnected =>
      _connection?.state == HubConnectionState.Connected;

  /// Connects to the hub. Safe to call multiple times — skips if already connected.
  Future<void> connect() async {
    if (isConnected) return;

    final token = await SecureStorageHelper.instance.getAccessToken();

    _connection = HubConnectionBuilder()
        .withUrl(
          EndPoint.chatHubUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token ?? '',
          ),
        )
        .withAutomaticReconnect()
        .build();

    _connection!.on('ConversationSummaryUpdated', _onSummaryUpdated);

    try {
      await _connection!.start();
    } catch (_) {
      // Connection failure is non-fatal — inbox still works via REST.
    }
  }

  /// Stops the hub connection and cleans up listeners.
  Future<void> disconnect() async {
    _connection?.off('ConversationSummaryUpdated');
    await _connection?.stop();
    _connection = null;
  }

  void _onSummaryUpdated(List<Object?>? args) {
    if (args == null || args.isEmpty) return;
    try {
      final update = ConversationSummaryUpdate.fromArgs(args);
      if (!_summaryController.isClosed) {
        _summaryController.add(update);
      }
    } catch (_) {}
  }
}
