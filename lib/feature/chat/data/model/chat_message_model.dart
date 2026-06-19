class ChatMessageModel {
  final String id;
  final String conversationId;
  final String senderUserId;
  final String content;
  final String? displayContent;
  final DateTime sentAtUtc;
  final DateTime? deliveredAtUtc;
  final DateTime? seenAtUtc;
  final int status;
  final bool isEdited;
  final DateTime? editedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  // Transient — true only for optimistic messages not yet confirmed by server
  final bool isSending;

  const ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.senderUserId,
    required this.content,
    this.displayContent,
    required this.sentAtUtc,
    this.deliveredAtUtc,
    this.seenAtUtc,
    required this.status,
    required this.isEdited,
    this.editedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    this.isSending = false,
  });

  bool get canEdit =>
      !isDeleted &&
      DateTime.now().difference(sentAtUtc).inMinutes < 5;

  // Dart supports max 6 fractional second digits; server may send 7+.
  // Also ensures the result is always UTC so .toLocal() works correctly.
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

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      senderUserId: json['senderUserId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      displayContent: json['displayContent'] as String?,
      sentAtUtc: _parseUtc(json['sentAtUtc'] as String?),
      deliveredAtUtc: json['deliveredAtUtc'] != null
          ? _parseUtc(json['deliveredAtUtc'] as String?)
          : null,
      seenAtUtc: json['seenAtUtc'] != null
          ? _parseUtc(json['seenAtUtc'] as String?)
          : null,
      status: json['status'] as int? ?? 0,
      isEdited: json['isEdited'] as bool? ?? false,
      editedAtUtc: json['editedAtUtc'] != null
          ? DateTime.tryParse(json['editedAtUtc'] as String)
          : null,
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAtUtc: json['deletedAtUtc'] != null
          ? DateTime.tryParse(json['deletedAtUtc'] as String)
          : null,
    );
  }

  ChatMessageModel copyWith({
    String? content,
    bool? isEdited,
    DateTime? editedAtUtc,
    bool? isDeleted,
    DateTime? deletedAtUtc,
  }) {
    return ChatMessageModel(
      id: id,
      conversationId: conversationId,
      senderUserId: senderUserId,
      content: content ?? this.content,
      displayContent: displayContent,
      sentAtUtc: sentAtUtc,
      deliveredAtUtc: deliveredAtUtc,
      seenAtUtc: seenAtUtc,
      status: status,
      isEdited: isEdited ?? this.isEdited,
      editedAtUtc: editedAtUtc ?? this.editedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
    );
  }
}

// Keep legacy alias so old unimported files compile.
typedef MessageModel = ChatMessageModel;
