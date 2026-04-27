import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/connectivity_guard.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/feature/auth/verify_otp/data/repo/verify_otp/verify_otp_repo.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class VerifyOtpImpleRepo implements VerifyOtpRepo {
  final ApiConsumer apiConsumer;

  VerifyOtpImpleRepo({required this.apiConsumer});
  @override
  Future<Either<Failure, String>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      if (!await ConnectivityGuard.hasInternet()) {
        return Left(NetworkFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await apiConsumer.post(
        EndPoint.verifyCode,
        data: {"email": email, "otp": otp},
      );
      final successMessage = response['message'];
      return Right(successMessage);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(LocaleKeys.error.tr()));
    }
  }
}
