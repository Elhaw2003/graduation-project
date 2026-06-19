import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/di.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/auth/login/data/repo/login_remote_imple_repo.dart';
import 'package:smart_guide/feature/auth/login/presentation/cubit/login_with_google/login_with_google_cubit.dart';
import 'package:smart_guide/feature/auth/login/presentation/cubit/login_email/login_with_email_cubit.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/widget/login_appbar.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/widget/login_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  // final UserTypeEnum userTypeEnum;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<LoginCubit>()),
        BlocProvider(create: (context) => sl<LoginWithGoogleCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(flexibleSpace: LoginAppbar()),
        body: LoginBody(),
      ),
    );
  }
}
