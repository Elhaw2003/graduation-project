part of 'resend_otp_cubit.dart';

sealed class ResendOtpState extends Equatable {
  const ResendOtpState();

  @override
  List<Object> get props => [];
}

final class ResendOtpInitialState extends ResendOtpState {}

final class ResendOtpLoadingState extends ResendOtpState {}

final class ResendOtpSuccessState extends ResendOtpState {
  final String message;

  const ResendOtpSuccessState({required this.message});
}

final class ResendOtpFailureState extends ResendOtpState {
  final String message;

  const ResendOtpFailureState({required this.message});
}
