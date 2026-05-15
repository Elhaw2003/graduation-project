import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/connectivity_guard.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/auth/login/data/model/login_google_response.dart';
import 'package:smart_guide/feature/auth/login/data/model/login_model.dart';
import 'package:smart_guide/feature/auth/login/data/repo/login_repo.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class LoginRemoteImpleRepo implements LoginRepo {
  final ApiConsumer apiConsumer;
  final SecureStorageHelper storage;

  LoginRemoteImpleRepo({required this.apiConsumer, required this.storage});

  @override
  Future<Either<Failure, LoginModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      if (!await ConnectivityGuard.hasInternet()) {
        return Left(NetworkFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await apiConsumer.post(
        EndPoint.login,
        data: {"email": email, "password": password},
      );

      final loginModel = LoginModel.fromJson(response);

      // 🔥 tokens
      await storage.saveTokens(
        accessToken: loginModel.token ?? '',
        refreshToken: loginModel.refreshToken ?? '',
        expiresAt: loginModel.expiresOn ?? '',
        refreshTokenExpiresOn: loginModel.refreshTokenExpiresOn ?? '',
      );

      return Right(loginModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (_) {
      return Left(ServerFailure(LocaleKeys.error.tr()));
    }
  }

  @override
  Future<Either<Failure, LoginGoogleResponseModel>> loginWithGoogle({
    required String idToken,
  }) async {
    try {
      if (!await ConnectivityGuard.hasInternet()) {
        return Left(NetworkFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await apiConsumer.post(
        EndPoint.googleSignIn,
        data: {ApiKey.idToken: idToken},
      );

      return Right(LoginGoogleResponseModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (_) {
      return Left(ServerFailure(LocaleKeys.error.tr()));
    }
  }
}
