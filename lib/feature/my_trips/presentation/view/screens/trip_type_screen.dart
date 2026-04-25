import 'package:flutter/material.dart';
import 'package:smart_guide/feature/my_trips/data/enum/trip_type_enum.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/trip_type/trips_type_body.dart';

class TripTypeScreen extends StatelessWidget {
  const TripTypeScreen({super.key, required this.tripType});
  final TripTypeEnum tripType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TripsTypeBody(tripType: tripType));
  }
}
