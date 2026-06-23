/// Payload received from SignalR `ConversationSummaryUpdated` event.
class ConversationSummaryUpdate {
  final String conversationId;
  final String lastMessagePreview;
  final DateTime lastMessageSentAtUtc;
  final int unreadCount;
  final bool isEdited;
  final bool isDeleted;

  const ConversationSummaryUpdate({
    required this.conversationId,
    required this.lastMessagePreview,
    required this.lastMessageSentAtUtc,
    this.unreadCount = 0,
    this.isEdited = false,
    this.isDeleted = false,
  });

  factory ConversationSummaryUpdate.fromArgs(List<Object?> args) {
    final map = args[0] as Map<String, dynamic>;
    return ConversationSummaryUpdate(
      conversationId: map['conversationId'] as String? ?? '',
      lastMessagePreview: map['lastMessagePreview'] as String? ?? '',
      lastMessageSentAtUtc: _parseUtc(map['lastMessageSentAtUtc'] as String?),
      unreadCount: map['unreadCount'] as int? ?? 0,
      isEdited: map['isEdited'] as bool? ?? false,
      isDeleted: map['isDeleted'] as bool? ?? false,
    );
  }

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
