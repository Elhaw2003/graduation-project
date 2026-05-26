class TouristProfileModel {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String country;
  final String whatsAppNumber;
  final String touristImage;

  const TouristProfileModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.country,
    required this.whatsAppNumber,
    required this.touristImage,
  });

  factory TouristProfileModel.fromJson(Map<String, dynamic> json) {
    return TouristProfileModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      country: json['country'] as String? ?? '',
      whatsAppNumber: json['whatsAppNumber'] as String? ?? '',
      touristImage: json['touristImage'] as String? ?? '',
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}
