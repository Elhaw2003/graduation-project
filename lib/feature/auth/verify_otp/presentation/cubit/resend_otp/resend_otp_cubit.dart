import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/auth/verify_otp/data/repo/resend_otp/resend_otp_repo.dart';

part 'resend_otp_state.dart';

class ResendOtpCubit extends Cubit<ResendOtpState> {
  ResendOtpCubit({required this.resendOtpRepo})
    : super(ResendOtpInitialState());
  final ResendOtpRepo resendOtpRepo;

  Future<void> resendOtp({required String email}) async {
    emit(ResendOtpLoadingState());
    var result = await resendOtpRepo.resendOtpRepo(email: email);
    result.fold(
      (l) => emit(ResendOtpFailureState(message: l.message)),
      (r) => emit(ResendOtpSuccessState(message: r)),
    );
  }
}
