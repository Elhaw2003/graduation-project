class ConversationModel {
  final String id;
  final String touristUserId;
  final String guideUserId;
  final String otherPartyUserId;
  final String otherPartyDisplayName;

  ConversationModel({
    required this.id,
    required this.touristUserId,
    required this.guideUserId,
    required this.otherPartyUserId,
    required this.otherPartyDisplayName,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      touristUserId: json['touristUserId'] ?? '',
      guideUserId: json['guideUserId'] ?? '',
      otherPartyUserId: json['otherPartyUserId'] ?? '',
      otherPartyDisplayName: json['otherPartyDisplayName'] ?? '',
    );
  }
}