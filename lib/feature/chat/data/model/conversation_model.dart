class ConversationModel {
  final String id;
  final String touristUserId;
  final String guideUserId;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;
  final String? profilePictureUrl;
  final String fullName;
  final String? lastMessagePreview;
  final DateTime? lastMessageSentAtUtc;
  final int unreadCount;
  final bool isMessagingBlocked;
  final String? otherPartyUserId;
  final String? otherPartyDisplayName;
  final String? otherPartyProfilePictureUrl;

  const ConversationModel({
    required this.id,
    required this.touristUserId,
    required this.guideUserId,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.profilePictureUrl,
    required this.fullName,
    this.lastMessagePreview,
    this.lastMessageSentAtUtc,
    required this.unreadCount,
    required this.isMessagingBlocked,
    this.otherPartyUserId,
    this.otherPartyDisplayName,
    this.otherPartyProfilePictureUrl,
  });

  static DateTime _parseUtc(String? s) {
    if (s == null || s.isEmpty) return DateTime.now().toUtc();
    final fixed = s.replaceFirstMapped(
      RegExp(r'(\.\d{6})\d+'),
      (m) => m.group(1)!,
    );
    final dt = DateTime.tryParse(fixed);
    if (dt == null) return DateTime.now().toUtc();
    return dt.isUtc ? dt : DateTime.utc(
      dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second, dt.millisecond,
    );
  }

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String? ?? '',
      touristUserId: json['touristUserId'] as String? ?? '',
      guideUserId: json['guideUserId'] as String? ?? '',
      createdAtUtc: _parseUtc(json['createdAtUtc'] as String?),
      updatedAtUtc: _parseUtc(json['updatedAtUtc'] as String?),
      profilePictureUrl: json['profilePictureUrl'] as String?,
      fullName: json['fullName'] as String? ?? '',
      lastMessagePreview: json['lastMessagePreview'] as String?,
      lastMessageSentAtUtc: json['lastMessageSentAtUtc'] != null
          ? _parseUtc(json['lastMessageSentAtUtc'] as String?)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      isMessagingBlocked: json['isMessagingBlocked'] as bool? ?? false,
      otherPartyUserId: json['otherPartyUserId'] as String?,
      otherPartyDisplayName: json['otherPartyDisplayName'] as String?,
      otherPartyProfilePictureUrl:
          json['otherPartyProfilePictureUrl'] as String?,
    );
  }

  ConversationModel copyWith({
    bool? isMessagingBlocked,
    String? lastMessagePreview,
    DateTime? lastMessageSentAtUtc,
    int? unreadCount,
  }) {
    return ConversationModel(
      id: id,
      touristUserId: touristUserId,
      guideUserId: guideUserId,
      createdAtUtc: createdAtUtc,
      updatedAtUtc: updatedAtUtc,
      profilePictureUrl: profilePictureUrl,
      fullName: fullName,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageSentAtUtc: lastMessageSentAtUtc ?? this.lastMessageSentAtUtc,
      unreadCount: unreadCount ?? this.unreadCount,
      isMessagingBlocked: isMessagingBlocked ?? this.isMessagingBlocked,
      otherPartyUserId: otherPartyUserId,
      otherPartyDisplayName: otherPartyDisplayName,
      otherPartyProfilePictureUrl: otherPartyProfilePictureUrl,
    );
  }
}
