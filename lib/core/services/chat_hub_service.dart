import 'dart:async';

import 'package:signalr_netcore/signalr_client.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/chat/data/model/conversation_summary_update.dart';

class ChatHubService {
  ChatHubService._();
  static final ChatHubService instance = ChatHubService._();

  HubConnection? _connection;

  final _summaryController =
      StreamController<ConversationSummaryUpdate>.broadcast();
  final _newMessageController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _messageEditedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _messageDeletedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _statusUpdatedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _readReceiptController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _presenceController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<ConversationSummaryUpdate> get summaryUpdates =>
      _summaryController.stream;
  Stream<Map<String, dynamic>> get newMessages => _newMessageController.stream;
  Stream<Map<String, dynamic>> get messageEdits =>
      _messageEditedController.stream;
  Stream<Map<String, dynamic>> get messageDeletes =>
      _messageDeletedController.stream;
  Stream<Map<String, dynamic>> get statusUpdates =>
      _statusUpdatedController.stream;
  Stream<Map<String, dynamic>> get readReceipts =>
      _readReceiptController.stream;
  Stream<Map<String, dynamic>> get presenceChanges =>
      _presenceController.stream;

  bool get isConnected => _connection?.state == HubConnectionState.Connected;

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
    _connection!.on('ReceiveChatMessage', _onReceiveChatMessage);
    _connection!.on('ChatMessageEdited', _onMessageEdited);
    _connection!.on('ChatMessageDeleted', _onMessageDeleted);
    _connection!.on('ChatMessageStatusUpdated', _onStatusUpdated);
    _connection!.on('ConversationReadReceipt', _onReadReceipt);
    _connection!.on('UserPresenceChanged', _onPresenceChanged);

    try {
      await _connection!.start();
    } catch (_) {
      // Connection failure is non-fatal — app still works via REST.
    }
  }

  /// Stops the hub connection and cleans up listeners.
  Future<void> disconnect() async {
    _connection?.off('ConversationSummaryUpdated');
    _connection?.off('ReceiveChatMessage');
    _connection?.off('ChatMessageEdited');
    _connection?.off('ChatMessageDeleted');
    _connection?.off('ChatMessageStatusUpdated');
    _connection?.off('ConversationReadReceipt');
    _connection?.off('UserPresenceChanged');
    await _connection?.stop();
    _connection = null;
  }

  // ─── Event handlers ───────────────────────────────────────────────────────

  void _onSummaryUpdated(List<Object?>? args) {
    _emitMap(args, (map) {
      final update = ConversationSummaryUpdate.fromArgs(args!);
      if (!_summaryController.isClosed) _summaryController.add(update);
    });
  }

  void _onReceiveChatMessage(List<Object?>? args) =>
      _emit(_newMessageController, args);

  void _onMessageEdited(List<Object?>? args) =>
      _emit(_messageEditedController, args);

  void _onMessageDeleted(List<Object?>? args) =>
      _emit(_messageDeletedController, args);

  void _onStatusUpdated(List<Object?>? args) =>
      _emit(_statusUpdatedController, args);

  void _onReadReceipt(List<Object?>? args) =>
      _emit(_readReceiptController, args);

  void _onPresenceChanged(List<Object?>? args) =>
      _emit(_presenceController, args);

  // ─── Helpers ──────────────────────────────────────────────────────────────

  void _emit(StreamController<Map<String, dynamic>> ctrl, List<Object?>? args) {
    if (args == null || args.isEmpty) return;
    try {
      final map = args[0] as Map<String, dynamic>;
      if (!ctrl.isClosed) ctrl.add(map);
    } catch (_) {}
  }

  void _emitMap(List<Object?>? args, void Function(Map<String, dynamic>) fn) {
    if (args == null || args.isEmpty) return;
    try {
      fn(args[0] as Map<String, dynamic>);
    } catch (_) {}
  }
}
