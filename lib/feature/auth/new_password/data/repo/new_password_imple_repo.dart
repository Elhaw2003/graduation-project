import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/feature/auth/new_password/data/repo/new_password_repo.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class NewPasswordImpleRepo implements NewPasswordRepo {
  final ApiConsumer apiConsumer;

  NewPasswordImpleRepo({required this.apiConsumer});
  @override
  Future<Either<Failure, String>> newPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String otp,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoint.newPassword,
        data: {
          "email": email,
          "newPassword": password,
          "confirmPassword": confirmPassword,
          "otp": otp,
        },
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
