import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/home/data/get_places/get_places_cubit.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_drawer_widget.dart';
import 'package:smart_guide/feature/home/presentation/widget/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Material(
        color: Colors.transparent,
        child: BlocProvider(
          create: (context) => PlacesCubit()..getPlaces(),
          child: HomeBody(),
        ),
      ),
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: AppColors.backgroundColor,
      body: const HomeBody(),
    );
  }
}
