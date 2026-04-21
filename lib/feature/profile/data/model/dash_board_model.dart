import 'package:smart_guide/generated/assets.dart';

class DashboardModel {
  final String title;
  final String subTitle;
  final String info;
  final String icon;

  DashboardModel({
    required this.title,
    required this.subTitle,
    required this.info,
    required this.icon,
  });
}

final List<DashboardModel> dashboardItems = [
  DashboardModel(
    title: "Favorites",
    subTitle: "Favorite Places",
    info: "12 Spots • 4 Cities",
    icon: Assets.imagesSvgFavorite,
  ),
  DashboardModel(
    title: "Trips",
    subTitle: "Upcoming Trips",
    info: "2 Trips • 1 Country",
    icon: Assets.imagesSvgTrips,
  ),
  DashboardModel(
    title: "Visited",
    subTitle: "Places you visited",
    info: "45 Spots • 12 Cities",
    icon: Assets.imagesSvgVisited,
  ),
  DashboardModel(
    title: "Saved",
    subTitle: "Saved for later",
    info: "8 Spots • 2 Cities",
    icon: Assets.imagesSvgSaved,
  ),
];
