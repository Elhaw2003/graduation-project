import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/cache/cache_helper.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/auth/login/data/repo/login_repo.dart';
import 'package:smart_guide/feature/auth/login/presentation/cubit/login_with_google/login_with_google_states.dart';
import 'package:smart_guide/feature/auth/login/presentation/cubit/login_email/login_with_email_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit({required this.loginRepo}) : super(LoginInitialStates());

  final LoginRepo loginRepo;

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoadingStates());

    final result = await loginRepo.login(email: email, password: password);

    result.fold((l) => emit(LoginFailureStates(message: l.message)), (r) async {
      // 🔥 هنا الصح
      final userType = r.userType;

      await SecureStorageHelper.instance.saveUserType(userType.name);
      await SecureStorageHelper.instance.saveUserData(
  userName: r.userName ?? '',
  profilePic: r.profilePictureUrl ?? '',
);
      emit(LoginSuccessStates(loginModel: r));
    });
  }
}
