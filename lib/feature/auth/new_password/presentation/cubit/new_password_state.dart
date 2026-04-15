part of 'new_password_cubit.dart';

sealed class NewPasswordState extends Equatable {
  const NewPasswordState();

  @override
  List<Object> get props => [];
}

final class NewPasswordInitialState extends NewPasswordState {}

final class NewPasswordLoadingState extends NewPasswordState {}

final class NewPasswordSuccessState extends NewPasswordState {
  final String message;
  const NewPasswordSuccessState({required this.message});
}

final class NewPasswordFailureState extends NewPasswordState {
  final String message;
  const NewPasswordFailureState({required this.message});
}
