import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/google_auth_service.dart';
import 'package:smart_guide/feature/auth/login/data/repo/login_repo.dart';
import 'package:smart_guide/feature/auth/login/presentation/cubit/login_with_google/login_with_google_states.dart';

class LoginWithGoogleCubit extends Cubit<LoginWithGoogleStates> {
  LoginWithGoogleCubit({required this.loginRepo})
    : super(LoginWithGoogleInitialStates());

  final LoginRepo loginRepo;
  Future<void> loginWithGoogle() async {
    emit(LoginWithGoogleLoadingStates());
    try {
      final googleService = GoogleAuthService();
      final idToken = await googleService.signIn();

      if (idToken == null) {
        emit(
          LoginWithGoogleFailureStates(message: 'Google login was cancelled'),
        );
        return;
      }
      var result = await loginRepo.loginWithGoogle(idToken: idToken);
      result.fold(
        (l) => emit(LoginWithGoogleFailureStates(message: l.message)),
        (r) => emit(LoginWithGoogleSuccessStates(loginWithGoogleModel: r)),
      );
    } catch (e) {
      emit(LoginWithGoogleFailureStates(message: e.toString()));
    }
  }
}
