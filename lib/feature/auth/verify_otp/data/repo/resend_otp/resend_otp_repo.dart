import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';

abstract class ResendOtpRepo {
  Future<Either<Failure, String>> resendOtpRepo({required String email});
}
