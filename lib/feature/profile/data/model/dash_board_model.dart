import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/generated/assets.dart';

class DashboardModel {
  final String title;
  final String subTitle;
  final String info;
  final String icon;
  final VoidCallback? onTap;

  DashboardModel({
    required this.title,
    required this.subTitle,
    required this.info,
    required this.icon,
    this.onTap,
  });
}

List<DashboardModel> dashboards(BuildContext context) {
  return [
    DashboardModel(
      title: "Favorites",
      subTitle: "Favorite Places",
      info: "12 Spots • 4 Cities",
      icon: Assets.imagesSvgFavorite,
      onTap: () {
        if (context.mounted) context.pushNamed(AppRoutes.favoritePlacesScreen);
      },
    ),
    DashboardModel(
      title: "Trips",
      subTitle: "Upcoming Trips",
      info: "2 Trips • 1 Country",
      icon: Assets.imagesSvgTrips,
      onTap: () {
        if (context.mounted) context.pushNamed(AppRoutes.myTripsScreen);
      },
    ),
    DashboardModel(
      title: "Visited",
      subTitle: "Places you visited",
      info: "45 Spots • 12 Cities",
      icon: Assets.imagesSvgVisited,
      onTap: () {},
    ),
    DashboardModel(
      title: "Saved",
      subTitle: "Saved for later",
      info: "8 Spots • 2 Cities",
      icon: Assets.imagesSvgSaved,
      onTap: () {},
    ),
  ];
}
