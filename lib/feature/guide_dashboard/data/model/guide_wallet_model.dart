class GuideWalletModel {
  final double walletBalance;
  final double pendingEarnings;
  final int pendingWithdrawals;

  const GuideWalletModel({
    required this.walletBalance,
    required this.pendingEarnings,
    required this.pendingWithdrawals,
  });

  factory GuideWalletModel.fromJson(Map<String, dynamic> json) {
    return GuideWalletModel(
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      pendingEarnings: (json['pendingEarnings'] as num?)?.toDouble() ?? 0.0,
      pendingWithdrawals: json['pendingWithdrawals'] as int? ?? 0,
    );
  }
}
