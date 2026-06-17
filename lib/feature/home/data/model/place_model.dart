class PlaceReviewModel {
  final num rating;
  final String review;
  final String createdAtUtc;

  PlaceReviewModel({
    required this.rating,
    required this.review,
    required this.createdAtUtc,
  });

  factory PlaceReviewModel.fromJson(Map<String, dynamic> json) {
    return PlaceReviewModel(
      rating: (json['rating'] ?? 0) as num,
      review: (json['review'] ?? '').toString(),
      createdAtUtc: (json['createdAtUtc'] ?? '').toString(),
    );
  }
}

class PlaceModel {
  final int id;
  final String name;
  final String type;
  final String description;
  final String location;
  final String city;
  final String governorate;
  final String imageUrl;
  final num rating;
  final String historicalBackground;
  final String createdBy;
  final String period;
  final int? startYear;
  final num averageRating;
  final int ratingsCount;
  final num? myRating;
  final List<PlaceReviewModel> reviews;

  PlaceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.location,
    required this.city,
    required this.governorate,
    required this.imageUrl,
    required this.rating,
    required this.historicalBackground,
    required this.createdBy,
    required this.period,
    this.startYear,
    this.averageRating = 0,
    this.ratingsCount = 0,
    this.myRating,
    this.reviews = const [],
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    final rawReviews = json['reviews'] as List<dynamic>? ?? [];
    return PlaceModel(
      id: json['id'] ?? json['placeId'] ?? 0,
      name: json['name'] ?? 'Unknown Place',
      type: json['type'] ?? 'Unknown Type',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      city: json['city'] ?? '',
      governorate: json['governorate'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? json['averageRating'] ?? 0) as num,
      historicalBackground: json['historicalBackground'] ?? '',
      createdBy: json['createdBy'] ?? '',
      period: json['period'] ?? '',
      startYear: json['startYear'] as int?,
      averageRating: (json['averageRating'] ?? json['rating'] ?? 0) as num,
      ratingsCount: (json['ratingsCount'] ?? 0) as int,
      myRating: json['myRating'] as num?,
      reviews: rawReviews
          .map((e) => PlaceReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'description': description,
    'location': location,
    'city': city,
    'governorate': governorate,
    'imageUrl': imageUrl,
    'rating': rating,
    'historicalBackground': historicalBackground,
    'createdBy': createdBy,
    'period': period,
    'startYear': startYear,
    'averageRating': averageRating,
    'ratingsCount': ratingsCount,
    'myRating': myRating,
    'reviews': reviews
        .map(
          (r) => {
            'rating': r.rating,
            'review': r.review,
            'createdAtUtc': r.createdAtUtc,
          },
        )
        .toList(),
  };
}

/// Returns placesImages[index] for the first 10 positions; falls back to the
/// API imageUrl for anything beyond that.
String resolvePlaceImage(String apiUrl, int index) {
  if (index >= 0 && index < placesImages.length) {
    return placesImages[index];
  }
  return apiUrl;
}

List<String> placesImages = [
  "https://almatar.com/blog/wp-content/uploads/2022/07/%D8%A7%D9%84%D8%B3%D9%8A%D8%A7%D8%AD%D8%A9-%D9%81%D9%8A-%D9%85%D8%B5%D8%B1.jpg",
  "https://cdn.alweb.com/thumbs/travel/article/fit710x532/%D8%A3%D9%85%D8%A7%D9%83%D9%86-%D8%B3%D9%8A%D8%A7%D8%AD%D9%8A%D8%A9-%D9%81%D9%8A-%D9%85%D8%B5%D8%B1-%D9%84%D9%84%D8%A7%D8%B3%D8%AA%D8%AC%D9%85%D8%A7%D9%85-%D8%A5%D9%84%D9%8A%D9%83-%D8%A3%D9%81%D8%B6%D9%84%D9%87%D8%A7.jpg",
  "https://media-cdn.tripadvisor.com/media/photo-s/1a/2b/f9/91/caption.jpg",
  "https://cnn-arabic-images.cnn.io/cloudinary/image/upload/w_900,h_506,c_fill,q_auto,g_center/cnnarabic/2020/07/01/images/158782.jpg",
  "https://cnn-arabic-images.cnn.io/cloudinary/image/upload/w_960,c_scale,q_auto/cnnarabic/2020/07/01/images/158753.jpg",
  "https://tripsegypt.net/storage/1665/conversions/111-webp.webp",
  "https://koon-sa.com/wp-content/uploads/2024/05/%D9%86%D8%B5-%D9%81%D9%82%D8%B1%D8%AA%D9%83-2024-05-30T203039.065.jpg",
  "https://blog.flysepehran.com/wp-content/uploads/2024/05/%D9%82%D9%84%D8%B9%D9%87-%D8%B5%D9%84%D8%A7%D8%AD-%D8%A7%D9%84%D8%AF%DB%8C%D9%86.jpg",
  "https://travelerlibrary.com/wp-content/uploads/Nile-Corniche.jpg",
  "https://travilia.com/uploads/0000/8/2024/08/23/g3qmlb-i.jpeg",
];
