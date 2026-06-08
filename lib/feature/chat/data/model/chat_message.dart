class MessageModel {
  final String id;
  final String conversationId;
  final String senderUserId;
  final String content;
  final DateTime sentAtUtc;
  final DateTime? seenAtUtc;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderUserId,
    required this.content,
    required this.sentAtUtc,
    this.seenAtUtc,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      senderUserId: json['senderUserId'] ?? '',
      content: json['content'] ?? '',
      sentAtUtc: DateTime.parse(json['sentAtUtc']),
      seenAtUtc: json['seenAtUtc'] != null
          ? DateTime.parse(json['seenAtUtc'])
          : null,
    );
  }
}