class TourGuideModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String country;
  final String whatsAppNumber;
  final String bio;
  final double pricePerDay;
  final double rating;
  final String profilePicture;
  final List<String> cities;
  final List<String> languages;
  final List<String> gallery;

  const TourGuideModel({
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

  factory TourGuideModel.fromJson(Map<String, dynamic> json) {
    return TourGuideModel(
      userId: json['userId'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      country: json['country'] as String? ?? '',
      whatsAppNumber: json['whatsAppNumber'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      profilePicture: json['profilePicture'] as String? ?? '',
      cities: (json['cities'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      languages: (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      gallery: (json['gallery'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'country': country,
      'whatsAppNumber': whatsAppNumber,
      'bio': bio,
      'pricePerDay': pricePerDay,
      'rating': rating,
      'profilePicture': profilePicture,
      'cities': cities,
      'languages': languages,
      'gallery': gallery,
    };
  }
}