class MonthlyEarningModel {
  final int year;
  final int month;
  final double earnings;

  const MonthlyEarningModel({
    required this.year,
    required this.month,
    required this.earnings,
  });

  factory MonthlyEarningModel.fromJson(Map<String, dynamic> json) {
    return MonthlyEarningModel(
      year: json['year'] as int? ?? 0,
      month: json['month'] as int? ?? 0,
      earnings: (json['earnings'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
