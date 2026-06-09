class CancelBookingResponse {
  final bool isSuccess;
  final String message;

  const CancelBookingResponse({
    required this.isSuccess,
    required this.message,
  });

  factory CancelBookingResponse.fromJson(Map<String, dynamic> json) {
    return CancelBookingResponse(
      isSuccess: json['isSuccess'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}
