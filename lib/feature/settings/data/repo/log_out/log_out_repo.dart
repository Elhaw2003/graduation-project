import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';

abstract class LogOutRepo {
  Future<Either<Failure, String>> logOut({required String refreshToken});
}
