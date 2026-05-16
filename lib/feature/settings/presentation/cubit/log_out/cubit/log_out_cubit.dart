import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/settings/data/repo/log_out/log_out_repo.dart';

part 'log_out_state.dart';

class LogOutCubit extends Cubit<LogOutState> {
  LogOutCubit({required this.logOutRepo}) : super(LogOutInitialState());
  final LogOutRepo logOutRepo;

  Future<void> logOut() async {
    emit(LogOutLoadingState());

    // Safely retrieve the refresh token
    final refreshToken = await SecureStorageHelper.instance.getRefreshToken();

    if (refreshToken == null) {
      // No token found — clear local data and proceed
      await SecureStorageHelper.instance.clearTokens();
      emit(const LogOutSuccessState(message: "Logged out"));
      return;
    }

    final result = await logOutRepo.logOut(refreshToken: refreshToken);

    result.fold(
      (failure) async {
        // Even if the server fails, consider clearing local data here
        // await SecureStorageHelper.instance.clearTokens();
        emit(LogOutFailureState(errorMessage: failure.message));
      },
      (successMessage) async {
        await SecureStorageHelper.instance.clearTokens();
        emit(LogOutSuccessState(message: successMessage));
      },
    );
  }
}
