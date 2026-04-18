import 'package:smart_guide/feature/auth/login/data/model/login_model.dart';

abstract class LoginStates {}

class LoginInitialStates extends LoginStates {}

class LoginLoadingStates extends LoginStates {}

class LoginSuccessStates extends LoginStates {
  final LoginModel loginModel;

  LoginSuccessStates({required this.loginModel});
}

class LoginFailureStates extends LoginStates {
  final String message;

  LoginFailureStates({required this.message});
}
