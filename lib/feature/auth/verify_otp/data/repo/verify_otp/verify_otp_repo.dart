import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';

abstract class VerifyOtpRepo {
  Future<Either<Failure, String>> verifyOtp({
    required String email,
    required String otp,
  });
}
