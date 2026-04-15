import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/new_password/data/repo/new_password_imple_repo.dart';
import 'package:smart_guide/feature/auth/new_password/presentation/cubit/new_password_cubit.dart';
import 'package:smart_guide/feature/auth/new_password/presentation/view/widget/new_password_body.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key, required this.email, required this.otp});
  final String email;
  final String otp;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewPasswordCubit(
        newPasswordRepo: NewPasswordImpleRepo(
          apiConsumer: DioConsumer(dio: Dio()),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.backgroundColor,
          leading: CustomArrowBackButton(),
        ),
        body: NewPasswordBody(email: email, otp: otp),
      ),
    );
  }
}
