import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/feature/auth/verify_otp/data/repo/resend_otp/resend_otp_repo.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ResendOtpImpleRepo implements ResendOtpRepo {
  final ApiConsumer apiConsumer;

  ResendOtpImpleRepo({required this.apiConsumer});
  @override
  Future<Either<Failure, String>> resendOtpRepo({required String email}) async {
    try {
      final response = await apiConsumer.post(
        EndPoint.resendOtp,
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
