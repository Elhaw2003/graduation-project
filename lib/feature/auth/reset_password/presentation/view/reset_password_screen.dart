import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/reset_password/data/repo/reset_password_imple_repo.dart';
import 'package:smart_guide/feature/auth/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:smart_guide/feature/auth/reset_password/presentation/view/widget/reset_password_body.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(
        resetPasswordRepo: ResetPasswordImpleRepo(
          apiConsumer: DioConsumer(dio: Dio()),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          leading: CustomArrowBackButton(),
        ),
        body: ResetPasswordBody(email: email),
      ),
    );
  }
}
