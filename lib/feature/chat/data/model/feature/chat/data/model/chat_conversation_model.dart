class ChatConversationModel {
  final String id;
  final String otherPartyUserId;
  final String otherPartyDisplayName;
  final String lastMessagePreview;
  final DateTime? lastMessageSentAtUtc;
  final int unreadCount;

  ChatConversationModel({
    required this.id,
    required this.otherPartyUserId,
    required this.otherPartyDisplayName,
    required this.lastMessagePreview,
    required this.lastMessageSentAtUtc,
    required this.unreadCount,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    return ChatConversationModel(
      id: json['id'] ?? '',
      otherPartyUserId: json['otherPartyUserId'] ?? '',
      otherPartyDisplayName: json['otherPartyDisplayName'] ?? '',
      lastMessagePreview: json['lastMessagePreview'] ?? '',
      lastMessageSentAtUtc: json['lastMessageSentAtUtc'] == null
          ? null
          : DateTime.parse(json['lastMessageSentAtUtc']),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}
