import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/auth/verify_otp/data/repo/verify_otp/verify_otp_repo.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit({required this.verifyOtpRepo})
    : super(VerifyOtpInitialState());
  final VerifyOtpRepo verifyOtpRepo;

  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(VerifyOtpLoadingState());
    var result = await verifyOtpRepo.verifyOtp(email: email, otp: otp);
    result.fold(
      (l) => emit(VerifyOtpFailureState(message: l.message)),
      (r) => emit(VerifyOtpSuccessState(message: r)),
    );
  }
}
