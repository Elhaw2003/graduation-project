class SavedGuideModel {
  final String guideId;
  final String name;
  final String location;
  final String? profilePictureUrl;

  SavedGuideModel({
    required this.guideId,
    required this.name,
    required this.location,
    this.profilePictureUrl,
  });

  factory SavedGuideModel.fromJson(Map<String, dynamic> json) {
    return SavedGuideModel(
      guideId: json['guideId'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? 'Egypt',
      profilePictureUrl: json['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'guideId': guideId,
    'name': name,
    'location': location,
    'profilePictureUrl': profilePictureUrl,
  };

  /// Create a copy with modified fields
  SavedGuideModel copyWith({
    String? guideId,
    String? name,
    String? location,
    String? profilePictureUrl,
  }) {
    return SavedGuideModel(
      guideId: guideId ?? this.guideId,
      name: name ?? this.name,
      location: location ?? this.location,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedGuideModel &&
          runtimeType == other.runtimeType &&
          guideId == other.guideId;

  @override
  int get hashCode => guideId.hashCode;
}
