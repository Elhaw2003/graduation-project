import 'package:smart_guide/generated/assets.dart';

class MyTripModel {
  final String id;
  final String title;
  final String image;
  final String date;
  final String guideName;
  final double totalPrice;
  final String status; // Upcoming أو Completed
  final double? rating; // موجود في الـ Past بس
  final String? startingPoint; // موجود في الـ Upcoming بس
  final String? startTime; // موجود في الـ Upcoming بس
  final String? pickupTime; // موجود في الـ Upcoming بس

  MyTripModel({
    required this.id,
    required this.title,
    required this.image,
    required this.date,
    required this.guideName,
    required this.totalPrice,
    required this.status,
    this.rating,
    this.startingPoint,
    this.startTime,
    this.pickupTime,
  });
}

List<MyTripModel> upcomingTripsStatic = [
  // MyTripModel(
  //   id: "1",
  //   title: "Giza Pyramids & Sphinx",
  //   image: Assets.imagesPngSphinx, // استخدم مسار الصورة عندك
  //   date: "May 10, 2026",
  //   guideName: "Mostafa Hekal",
  //   totalPrice: 150.0,
  //   status: "Upcoming",
  //   startingPoint: "Giza Plateau Entrance",
  //   startTime: "09:00 AM",
  //   pickupTime: "08:30 AM",
  // ),
  // MyTripModel(
  //   id: "2",
  //   title: "Luxor Temple Tour",
  //   image: Assets.imagesPngSphinx,
  //   date: "June 05, 2026",
  //   guideName: "Ahmed Ali",
  //   totalPrice: 200.0,
  //   status: "Upcoming",
  //   startingPoint: "Hotel Lobby",
  //   startTime: "07:00 AM",
  //   pickupTime: "06:45 AM",
  // ),
  // MyTripModel(
  //   id: "1",
  //   title: "Giza Pyramids & Sphinx",
  //   image: Assets.imagesPngSphinx, // استخدم مسار الصورة عندك
  //   date: "May 10, 2026",
  //   guideName: "Mostafa Hekal",
  //   totalPrice: 150.0,
  //   status: "Upcoming",
  //   startingPoint: "Giza Plateau Entrance",
  //   startTime: "09:00 AM",
  //   pickupTime: "08:30 AM",
  // ),
  // MyTripModel(
  //   id: "2",
  //   title: "Luxor Temple Tour",
  //   image: Assets.imagesPngSphinx,
  //   date: "June 05, 2026",
  //   guideName: "Ahmed Ali",
  //   totalPrice: 200.0,
  //   status: "Upcoming",
  //   startingPoint: "Hotel Lobby",
  //   startTime: "07:00 AM",
  //   pickupTime: "06:45 AM",
  // ),
  // MyTripModel(
  //   id: "1",
  //   title: "Giza Pyramids & Sphinx",
  //   image: Assets.imagesPngSphinx, // استخدم مسار الصورة عندك
  //   date: "May 10, 2026",
  //   guideName: "Mostafa Hekal",
  //   totalPrice: 150.0,
  //   status: "Upcoming",
  //   startingPoint: "Giza Plateau Entrance",
  //   startTime: "09:00 AM",
  //   pickupTime: "08:30 AM",
  // ),
  // MyTripModel(
  //   id: "2",
  //   title: "Luxor Temple Tour",
  //   image: Assets.imagesPngSphinx,
  //   date: "June 05, 2026",
  //   guideName: "Ahmed Ali",
  //   totalPrice: 200.0,
  //   status: "Upcoming",
  //   startingPoint: "Hotel Lobby",
  //   startTime: "07:00 AM",
  //   pickupTime: "06:45 AM",
  // ),
];

List<MyTripModel> pastTripsStatic = [
  MyTripModel(
    id: "101",
    title: "The Giza Pyramid & Sphinx",
    image: Assets.imagesPngSphinx,
    date: "Jan 15, 2026",
    guideName: "Mostafa",
    totalPrice: 120.0,
    status: "Completed",
    rating: 5.0, // التقييم اللي هيظهر نجوم
  ),
  MyTripModel(
    id: "102",
    title: "Old Cairo & Khan el-Khalili",
    image: Assets.imagesPngSphinx,
    date: "Feb 20, 2026",
    guideName: "Sara Mansour",
    totalPrice: 90.0,
    status: "Completed",
    rating: 4.5,
  ),
  MyTripModel(
    id: "103",
    title: "Alexandria Day Trip",
    image: Assets.imagesPngSphinx,
    date: "March 01, 2026",
    guideName: "Hany Gamal",
    totalPrice: 180.0,
    status: "Completed",
    rating: 4.8,
  ),
  MyTripModel(
    id: "101",
    title: "The Giza Pyramid & Sphinx",
    image: Assets.imagesPngSphinx,
    date: "Jan 15, 2026",
    guideName: "Mostafa",
    totalPrice: 120.0,
    status: "Completed",
    rating: 5.0, // التقييم اللي هيظهر نجوم
  ),
  MyTripModel(
    id: "102",
    title: "Old Cairo & Khan el-Khalili",
    image: Assets.imagesPngSphinx,
    date: "Feb 20, 2026",
    guideName: "Sara Mansour",
    totalPrice: 90.0,
    status: "Completed",
    rating: 4.5,
  ),
  MyTripModel(
    id: "103",
    title: "Alexandria Day Trip",
    image: Assets.imagesPngSphinx,
    date: "March 01, 2026",
    guideName: "Hany Gamal",
    totalPrice: 180.0,
    status: "Completed",
    rating: 4.8,
  ),
  MyTripModel(
    id: "101",
    title: "The Giza Pyramid & Sphinx",
    image: Assets.imagesPngSphinx,
    date: "Jan 15, 2026",
    guideName: "Mostafa",
    totalPrice: 120.0,
    status: "Completed",
    rating: 5.0, // التقييم اللي هيظهر نجوم
  ),
  MyTripModel(
    id: "102",
    title: "Old Cairo & Khan el-Khalili",
    image: Assets.imagesPngSphinx,
    date: "Feb 20, 2026",
    guideName: "Sara Mansour",
    totalPrice: 90.0,
    status: "Completed",
    rating: 4.5,
  ),
  MyTripModel(
    id: "103",
    title: "Alexandria Day Trip",
    image: Assets.imagesPngSphinx,
    date: "March 01, 2026",
    guideName: "Hany Gamal",
    totalPrice: 180.0,
    status: "Completed",
    rating: 4.8,
  ),
];
