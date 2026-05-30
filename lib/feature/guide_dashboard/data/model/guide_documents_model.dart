class GuideDocumentsModel {
  final String guideId;
  final String fullName;
  final String nationalIdImageUrl;
  final String licenseImageUrl;
  final String verificationStatus;

  const GuideDocumentsModel({
    required this.guideId,
    required this.fullName,
    required this.nationalIdImageUrl,
    required this.licenseImageUrl,
    required this.verificationStatus,
  });

  factory GuideDocumentsModel.fromJson(Map<String, dynamic> json) {
    return GuideDocumentsModel(
      guideId: json['guideId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      nationalIdImageUrl: json['nationalIdImageUrl'] as String? ?? '',
      licenseImageUrl: json['licenseImageUrl'] as String? ?? '',
      verificationStatus: json['verificationStatus'] as String? ?? '',
    );
  }
}
