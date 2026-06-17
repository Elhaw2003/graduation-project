class BookingModel {
  final String id;
  final String status;
  final double totalPrice;
  final String paymentMethod;
  final String createdAtUtc;
  final BookingSlotModel slot;
  final List<BookingAddOnModel> selectedAddOns;

  const BookingModel({
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.paymentMethod,
    required this.createdAtUtc,
    required this.slot,
    required this.selectedAddOns,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] as String? ?? 'cash',
      createdAtUtc: json['createdAtUtc'] as String? ?? '',
      slot: json['slot'] != null
          ? BookingSlotModel.fromJson(json['slot'] as Map<String, dynamic>)
          : const BookingSlotModel(
              id: '',
              date: '',
              startTime: '',
              endTime: '',
            ),
      selectedAddOns:
          (json['selectedAddOns'] as List?)
              ?.map(
                (e) => BookingAddOnModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  DateTime? get parsedCreatedAt => DateTime.tryParse(createdAtUtc);

  bool get isUpcoming =>
      status.toLowerCase() == 'pending' || status.toLowerCase() == 'confirmed';

  bool get isPast =>
      status.toLowerCase() == 'completed' ||
      status.toLowerCase() == 'cancelled';

  String get paymentMethodLabel =>
      paymentMethod.toLowerCase() == 'online' ? 'Online' : 'Cash';
}

class BookingSlotModel {
  final String id;
  final String date;
  final String startTime;
  final String endTime;

  const BookingSlotModel({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory BookingSlotModel.fromJson(Map<String, dynamic> json) {
    return BookingSlotModel(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
    );
  }

  String get displayTime => '$startTime - $endTime';
}

class BookingAddOnModel {
  final String id;
  final String title;
  final double price;

  const BookingAddOnModel({
    required this.id,
    required this.title,
    required this.price,
  });

  factory BookingAddOnModel.fromJson(Map<String, dynamic> json) {
    return BookingAddOnModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
