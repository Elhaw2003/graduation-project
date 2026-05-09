class TourGuideModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String country;
  final String? whatsAppNumber;
  final String? bio;
  final double rating;
  final String? profilePicture;

  TourGuideModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.country,
    this.whatsAppNumber,
    this.bio,
    required this.rating,
    this.profilePicture,
  });

  factory TourGuideModel.fromJson(Map<String, dynamic> json) {
    return TourGuideModel(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      email: json['email'],
      country: json['country'],
      whatsAppNumber: json['whatsAppNumber'],
      bio: json['bio'],
      rating: (json['rating'] ?? 0).toDouble(),
      profilePicture: json['profilePicture'],
    );
  }
}