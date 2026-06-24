import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/di.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/Tour/data/tours/tours_cubit.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_drawer_widget.dart';
import 'package:smart_guide/feature/home/presentation/widget/home_body.dart';
import 'package:smart_guide/feature/notifications/data/logic/notification_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: AppColors.backgroundColor,

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.read<NotificationCubit>().getUnreadCount();

          print(context.read<NotificationCubit>().unreadCount);
        },
        child: const Icon(Icons.notifications),
      ),

      body: BlocProvider(
        create: (_) => sl<ToursCubit>()..getTours(),
        child: const HomeBody(),
      ),
    );
  }
}
