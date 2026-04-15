import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/auth/login/data/model/login_google_response.dart';
import 'package:smart_guide/feature/auth/login/data/model/login_model.dart';
import 'package:smart_guide/feature/auth/login/data/repo/login_repo.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class LoginRemoteImpleRepo implements LoginRepo {
  final ApiConsumer apiConsumer;
  final SecureStorageHelper storage; // تمرير الـ Storage هنا

  LoginRemoteImpleRepo({required this.apiConsumer, required this.storage});

  @override
  Future<Either<Failure, LoginModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoint.login,
        data: {"email": email, "password": password},
      );

      final loginRespone = LoginModel.fromJson(response);

      // حفظ التوكنات بأمان
      await storage.saveTokens(
        accessToken: loginRespone.token ?? '',
        refreshToken: loginRespone.refreshToken ?? '',
        expiresAt: loginRespone.expiresOn ?? '',
        refreshTokenExpiresOn: loginRespone.refreshTokenExpiresOn ?? '',
      );

      return Right(loginRespone);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      // طباعة الخطأ لمعرفته أثناء التطوير
      return Left(ServerFailure(LocaleKeys.error.tr()));
    }
  }

  @override
  Future<Either<Failure, LoginGoogleResponseModel>> loginWithGoogle({
    required String idToken,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoint.googleSignIn,
        data: {ApiKey.idToken: idToken},
      );

      final loginRespone = LoginGoogleResponseModel.fromJson(response);

      // تفعيل الحفظ للـ Google Login برضه مهم عشان الـ Session تفضل شغالة
      /*
      await storage.saveTokens(
         accessToken: loginRespone.accessToken,
         ...
      );
      */

      return Right(loginRespone);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(LocaleKeys.error.tr()));
    }
  }
}
