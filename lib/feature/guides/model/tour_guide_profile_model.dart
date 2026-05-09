class TourGuideProfileModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String country;
  final String? whatsAppNumber;
  final String? bio;
  final double? pricePerDay;
  final double rating;
  final String? profilePicture;
  final List<String> cities;
  final List<String> languages;
  final List<String> gallery;

  TourGuideProfileModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.country,
    required this.whatsAppNumber,
    required this.bio,
    required this.pricePerDay,
    required this.rating,
    required this.profilePicture,
    required this.cities,
    required this.languages,
    required this.gallery,
  });

  factory TourGuideProfileModel.fromJson(Map<String, dynamic> json) {
    return TourGuideProfileModel(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      email: json['email'],
      country: json['country'],
      whatsAppNumber: json['whatsAppNumber'],
      bio: json['bio'],
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble(),
      rating: (json['rating'] as num).toDouble(),
      profilePicture: json['profilePicture'],
      cities: List<String>.from(json['cities'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      gallery: List<String>.from(json['gallery'] ?? []),
    );
  }
}