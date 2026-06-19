/// Payload received from SignalR `ConversationSummaryUpdated` event.
class ConversationSummaryUpdate {
  final String conversationId;
  final String lastMessagePreview;
  final DateTime lastMessageSentAtUtc;

  const ConversationSummaryUpdate({
    required this.conversationId,
    required this.lastMessagePreview,
    required this.lastMessageSentAtUtc,
  });

  factory ConversationSummaryUpdate.fromArgs(List<Object?> args) {
    final map = args[0] as Map<String, dynamic>;
    return ConversationSummaryUpdate(
      conversationId: map['conversationId'] as String? ?? '',
      lastMessagePreview: map['lastMessagePreview'] as String? ?? '',
      lastMessageSentAtUtc: _parseUtc(map['lastMessageSentAtUtc'] as String?),
    );
  }

  // Mirrors the same logic in ChatMessageModel / ConversationModel.
  // Dart supports max 6 fractional second digits; server may send 7+.
  static DateTime _parseUtc(String? s) {
    if (s == null || s.isEmpty) return DateTime.now().toUtc();
    final fixed = s.replaceFirstMapped(
      RegExp(r'(\.\d{6})\d+'),
      (m) => m.group(1)!,
    );
    final dt = DateTime.tryParse(fixed);
    if (dt == null) return DateTime.now().toUtc();
    return dt.isUtc
        ? dt
        : DateTime.utc(
            dt.year, dt.month, dt.day,
            dt.hour, dt.minute, dt.second, dt.millisecond,
          );
  }
}
