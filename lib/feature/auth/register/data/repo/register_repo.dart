import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/feature/auth/register/data/model/register_request_model.dart';
import 'package:smart_guide/feature/auth/register/data/model/register_response_model.dart';

abstract class RegisterRepo {
  Future<Either<Failure, RegisterResponseModel>> register({
    required RegisterRequestModel registerRequestModel,
  });
}
