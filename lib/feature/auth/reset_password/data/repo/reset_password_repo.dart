import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';

abstract class ResetPasswordRepo {
  Future<Either<Failure, String>> resetPassword({required String email});
}
