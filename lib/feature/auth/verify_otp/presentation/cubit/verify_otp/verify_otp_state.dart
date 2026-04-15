part of 'verify_otp_cubit.dart';

sealed class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object> get props => [];
}

final class VerifyOtpInitialState extends VerifyOtpState {}

final class VerifyOtpLoadingState extends VerifyOtpState {}

final class VerifyOtpSuccessState extends VerifyOtpState {
  final String message;

  const VerifyOtpSuccessState({required this.message});
}

final class VerifyOtpFailureState extends VerifyOtpState {
  final String message;

  const VerifyOtpFailureState({required this.message});
}
