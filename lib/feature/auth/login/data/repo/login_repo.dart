import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/feature/auth/login/data/model/login_google_response.dart';
import 'package:smart_guide/feature/auth/login/data/model/login_model.dart';

abstract class LoginRepo {
  Future<Either<Failure, LoginModel>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, LoginGoogleResponseModel>> loginWithGoogle({
    required String idToken,
  });
}
