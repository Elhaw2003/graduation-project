part of 'log_out_cubit.dart';

sealed class LogOutState extends Equatable {
  const LogOutState();

  @override
  List<Object> get props => [];
}

final class LogOutInitialState extends LogOutState {}

final class LogOutLoadingState extends LogOutState {}

final class LogOutSuccessState extends LogOutState {
  final String message;
  const LogOutSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class LogOutFailureState extends LogOutState {
  final String errorMessage;
  const LogOutFailureState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
