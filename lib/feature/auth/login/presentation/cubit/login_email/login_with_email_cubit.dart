import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/auth/login/data/repo/login_repo.dart';
import 'package:smart_guide/feature/auth/login/presentation/cubit/login_email/login_with_email_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit({required this.loginRepo}) : super(LoginInitialStates());

  final LoginRepo loginRepo;
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoadingStates());
    var result = await loginRepo.login(email: email, password: password);
    result.fold(
      (l) => emit(LoginFailureStates(message: l.message)),
      (r) => emit(LoginSuccessStates(loginModel: r)),
    );
  }
}
