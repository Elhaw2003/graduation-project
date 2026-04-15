import 'package:smart_guide/feature/auth/register/data/model/register_response_model.dart';

abstract class RegisterStates {}

class RegisterInitialStates extends RegisterStates {}

class RegisterLoadingStates extends RegisterStates {}

class RegisterSuccessStates extends RegisterStates {
  final RegisterResponseModel registerResponseModel;

  RegisterSuccessStates({required this.registerResponseModel});
}

class RegisterFailureStates extends RegisterStates {
  final String message;

  RegisterFailureStates({required this.message});
}
