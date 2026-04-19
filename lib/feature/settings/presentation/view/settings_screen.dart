import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/feature/settings/data/repo/log_out/log_out_repo_imple.dart';
import 'package:smart_guide/feature/settings/presentation/cubit/log_out/cubit/log_out_cubit.dart';
import 'package:smart_guide/feature/settings/presentation/view/widget/settings_appbar.dart';
import 'package:smart_guide/feature/settings/presentation/view/widget/settings_body.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogOutCubit(
        logOutRepo: LogOutRepoImple(apiConsumer: DioConsumer(dio: Dio())),
      ),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(slivers: [SettingsAppbar(), SettingsBody()]),
        ),
      ),
    );
  }
}
