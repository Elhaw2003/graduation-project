import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/connectivity_guard.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/feature/auth/reset_password/data/repo/reset_password_repo.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ResetPasswordImpleRepo implements ResetPasswordRepo {
  final ApiConsumer apiConsumer;

  ResetPasswordImpleRepo({required this.apiConsumer});
  @override
  Future<Either<Failure, String>> resetPassword({required String email}) async {
    try {
      if (!await ConnectivityGuard.hasInternet()) {
        return Left(NetworkFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await apiConsumer.post(
        EndPoint.forgotPassword,
        data: {"email": email},
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
