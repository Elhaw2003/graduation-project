import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/auth/reset_password/data/repo/reset_password_repo.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({required this.resetPasswordRepo})
    : super(ResetPasswordInitialState());
  final ResetPasswordRepo resetPasswordRepo;

  Future<void> resetPassword({required String email}) async {
    emit(ResetPasswordLoadingState());
    var result = await resetPasswordRepo.resetPassword(email: email);
    result.fold(
      (l) => emit(ResetPasswordFailureState(message: l.message)),
      (r) => emit(ResetPasswordSuccessState(message: r)),
    );
  }
}
