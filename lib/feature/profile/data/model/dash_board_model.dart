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

List<DashboardModel> dashboards(
  BuildContext context, {
  int favoritesCount = 0,
  int tripsCount = 0,
  int placesCount = 0,
}) {
  return [
    DashboardModel(
      title: "Favorites",
      subTitle: "Favorite Guides",
      info: '$favoritesCount Guides',
      icon: Assets.imagesSvgFavorite,
      onTap: () {
        if (context.mounted) context.pushNamed(AppRoutes.guidesSavedScreen);
      },
    ),
    DashboardModel(
      title: "Trips",
      subTitle: "My Trips",
      info: '$tripsCount Trips',
      icon: Assets.imagesSvgTrips,
      onTap: () {
        if (context.mounted) context.pushNamed(AppRoutes.myTripsScreen);
      },
    ),
    // DashboardModel(
    //   title: "Visited",
    //   subTitle: "Places you visited",
    //   info: "45 Spots • 12 Cities",
    //   icon: Assets.imagesSvgVisited,
    //   onTap: () {},
    // ),
    DashboardModel(
      title: "Places",
      subTitle: "Favorite Spots",
      info: '$placesCount Places',
      icon: Assets.imagesSvgSaved,
      onTap: () {
        if (context.mounted) context.pushNamed(AppRoutes.savedScreen);
      },
    ),
  ];
}
