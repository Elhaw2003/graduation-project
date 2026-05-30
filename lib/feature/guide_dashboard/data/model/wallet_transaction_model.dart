class WalletTransactionModel {
  final String transactionId;
  final double amount;
  final String type;
  final String status;
  final String createdAt;

  const WalletTransactionModel({
    required this.transactionId,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      transactionId: json['transactionId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  DateTime? get parsedDate => DateTime.tryParse(createdAt);
}
