import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/feature/settings/data/repo/log_out/log_out_repo.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class LogOutRepoImple implements LogOutRepo {
  final ApiConsumer apiConsumer;
  LogOutRepoImple({required this.apiConsumer});
  @override
  Future<Either<Failure, String>> logOut({required String refreshToken}) async {
    try {
      final response = await apiConsumer.post(
        EndPoint.logout,
        data: {"refreshToken": refreshToken},
      );
      print("LogOutRepoImple logOut response: $response");
      return Right(response['message'] ?? "Logged out successfully");
    } on ServerException catch (e) {
      print("LogOutRepoImple logOut error: ${e.errModel.errorMessage}");
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      print("LogOutRepoImple logOut error: $e");
      return Left(ServerFailure(LocaleKeys.error.tr()));
    }
  }
}
