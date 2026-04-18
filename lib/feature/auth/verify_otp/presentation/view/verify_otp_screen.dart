import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/verify_otp/data/repo/resend_otp/resend_otp_imple_repo.dart';
import 'package:smart_guide/feature/auth/verify_otp/data/repo/verify_otp/verify_otp_imple_repo.dart';
import 'package:smart_guide/feature/auth/verify_otp/presentation/cubit/resend_otp/resend_otp_cubit.dart';
import 'package:smart_guide/feature/auth/verify_otp/presentation/cubit/verify_otp/verify_otp_cubit.dart';
import 'package:smart_guide/feature/auth/verify_otp/presentation/view/widget/verify_otp_body.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VerifyOtpCubit(
            verifyOtpRepo: VerifyOtpImpleRepo(
              apiConsumer: DioConsumer(dio: Dio()),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ResendOtpCubit(
            resendOtpRepo: ResendOtpImpleRepo(
              apiConsumer: DioConsumer(dio: Dio()),
            ),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          leading: CustomArrowBackButton(),
        ),
        body: VerifyOtpBody(email: email),
      ),
    );
  }
}
