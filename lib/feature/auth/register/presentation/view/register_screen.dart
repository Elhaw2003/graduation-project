import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/auth/register/data/repo/register_remote_imple_repo.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/register/register_cubit.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/register_body.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key, required this.userTypeEnum});
  final UserTypeEnum userTypeEnum;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(
        registerRepo: RegisterRemoteImpleRepo(
          apiConsumer: DioConsumer(dio: Dio()),
        ),
      ),
      child: Scaffold(body: RegisterBody(userTypeEnum: userTypeEnum)),
    );
  }
}
