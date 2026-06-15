class GuideBookingModel {
  final String id;
  final String status;
  final double totalPrice;
  final String paymentMethod;
  final String createdAtUtc;
  final GuideBookingSlotModel? slot;
  final List<GuideBookingAddOnModel> selectedAddOns;

  const GuideBookingModel({
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.paymentMethod,
    required this.createdAtUtc,
    required this.slot,
    required this.selectedAddOns,
  });

  factory GuideBookingModel.fromJson(Map<String, dynamic> json) {
    return GuideBookingModel(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] as String? ?? '',
      createdAtUtc: json['createdAtUtc'] as String? ?? '',
      slot: json['slot'] != null
          ? GuideBookingSlotModel.fromJson(
              json['slot'] as Map<String, dynamic>)
          : null,
      selectedAddOns: (json['selectedAddOns'] as List<dynamic>?)
              ?.map((e) => GuideBookingAddOnModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class GuideBookingSlotModel {
  final String id;
  final String date;
  final String startTime;
  final String endTime;

  const GuideBookingSlotModel({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory GuideBookingSlotModel.fromJson(Map<String, dynamic> json) {
    return GuideBookingSlotModel(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
    );
  }
}

class GuideBookingAddOnModel {
  final String tourAddOnId;
  final String title;
  final double price;

  const GuideBookingAddOnModel({
    required this.tourAddOnId,
    required this.title,
    required this.price,
  });

  factory GuideBookingAddOnModel.fromJson(Map<String, dynamic> json) {
    return GuideBookingAddOnModel(
      tourAddOnId: json['tourAddOnId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
