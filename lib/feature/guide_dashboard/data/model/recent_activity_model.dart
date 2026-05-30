class RecentActivityModel {
  final String occurredAtUtc;
  final String type;
  final String title;
  final String description;

  const RecentActivityModel({
    required this.occurredAtUtc,
    required this.type,
    required this.title,
    required this.description,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      occurredAtUtc: json['occurredAtUtc'] as String? ?? '',
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  DateTime? get parsedDate => DateTime.tryParse(occurredAtUtc);
}
