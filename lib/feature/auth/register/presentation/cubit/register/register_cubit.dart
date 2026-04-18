import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/auth/register/data/model/register_request_model.dart';
import 'package:smart_guide/feature/auth/register/data/repo/register_repo.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/register/register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit({required this.registerRepo}) : super(RegisterInitialStates());

  final RegisterRepo registerRepo;
  Future<void> register({
    required RegisterRequestModel registerRequestModel,
  }) async {
    emit(RegisterLoadingStates());
    var result = await registerRepo.register(
      registerRequestModel: registerRequestModel,
    );
    result.fold(
      (l) => emit(RegisterFailureStates(message: l.message)),
      (r) => emit(RegisterSuccessStates(registerResponseModel: r)),
    );
  }
}
