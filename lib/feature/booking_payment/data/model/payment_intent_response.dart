class PaymentIntentResponse {
  final bool isSuccess;
  final String clientSecret;
  final String publishableKey;
  final double amount;
  final String currency;
  final String message;

  const PaymentIntentResponse({
    required this.isSuccess,
    required this.clientSecret,
    required this.publishableKey,
    required this.amount,
    required this.currency,
    required this.message,
  });

  factory PaymentIntentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentIntentResponse(
      isSuccess: json['isSuccess'] as bool? ?? false,
      clientSecret: json['clientSecret'] as String? ?? '',
      publishableKey: json['publishableKey'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'usd',
      message: json['message'] as String? ?? '',
    );
  }
}
