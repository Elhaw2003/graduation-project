import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';

abstract class NewPasswordRepo {
  Future<Either<Failure, String>> newPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String otp,
  });
}
