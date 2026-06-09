class CreateBookingResponse {
  final bool isSuccess;
  final String message;
  final String bookingId;

  const CreateBookingResponse({
    required this.isSuccess,
    required this.message,
    required this.bookingId,
  });

  factory CreateBookingResponse.fromJson(Map<String, dynamic> json) {
    return CreateBookingResponse(
      isSuccess: json['isSuccess'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      bookingId: json['bookingId'] as String? ?? '',
    );
  }
}
