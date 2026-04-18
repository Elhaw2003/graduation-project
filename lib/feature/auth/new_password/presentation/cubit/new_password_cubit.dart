import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/auth/new_password/data/repo/new_password_repo.dart';

part 'new_password_state.dart';

class NewPasswordCubit extends Cubit<NewPasswordState> {
  NewPasswordCubit({required this.newPasswordRepo})
    : super(NewPasswordInitialState());
  final NewPasswordRepo newPasswordRepo;

  Future<void> newPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String otp,
  }) async {
    emit(NewPasswordLoadingState());
    var result = await newPasswordRepo.newPassword(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      otp: otp,
    );
    result.fold(
      (l) => emit(NewPasswordFailureState(message: l.message)),
      (r) => emit(NewPasswordSuccessState(message: r)),
    );
  }
}
