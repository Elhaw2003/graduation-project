class TourSlotModel {
  final String id;
  final String date;
  final String startTime;
  final String endTime;

  const TourSlotModel({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory TourSlotModel.fromJson(Map<String, dynamic> json) {
    return TourSlotModel(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
    );
  }

  String get displayTime => '$startTime - $endTime';
}
