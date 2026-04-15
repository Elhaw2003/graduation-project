import 'package:smart_guide/feature/auth/login/data/model/login_google_response.dart';

abstract class LoginWithGoogleStates {}

class LoginWithGoogleInitialStates extends LoginWithGoogleStates {}

class LoginWithGoogleLoadingStates extends LoginWithGoogleStates {}

class LoginWithGoogleSuccessStates extends LoginWithGoogleStates {
  final LoginGoogleResponseModel loginWithGoogleModel;

  LoginWithGoogleSuccessStates({required this.loginWithGoogleModel});
}

class LoginWithGoogleFailureStates extends LoginWithGoogleStates {
  final String message;

  LoginWithGoogleFailureStates({required this.message});
}
