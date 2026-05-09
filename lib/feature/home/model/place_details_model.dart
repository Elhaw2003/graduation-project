class PlaceDetailsModel {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String location;
  final int rating;
  final String period;
  final String createdBy;

  PlaceDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.rating,
    required this.period,
    required this.createdBy,
  });

  factory PlaceDetailsModel.fromJson(Map<String, dynamic> json) {
    return PlaceDetailsModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      location: json['location'],
      rating: json['rating'],
      period: json['period'],
      createdBy: json['createdBy'],
    );
  }
}