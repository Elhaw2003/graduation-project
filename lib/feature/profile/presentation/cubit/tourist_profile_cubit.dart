import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/profile/data/repo/tourist_profile_repo.dart';
import 'package:smart_guide/feature/profile/presentation/cubit/tourist_profile_states.dart';

class TouristProfileCubit extends Cubit<TouristProfileState> {
  final TouristProfileRepo touristProfileRepo;

  TouristProfileCubit({required this.touristProfileRepo})
      : super(TouristProfileInitial());

  Future<void> getTouristProfile({required String id}) async {
    emit(TouristProfileLoading());

    final result = await touristProfileRepo.getTouristProfile(id: id);

    result.fold(
      (failure) => emit(TouristProfileFailure(failure.message)),
      (profile) => emit(TouristProfileSuccess(profile)),
    );
  }

  Future<void> updateTouristProfile({
    required String id,
    required String firstName,
    required String lastName,
    required String country,
    required String whatsAppNumber,
    String? imagePath,
  }) async {
    emit(TouristProfileUpdateLoading());

    final result = await touristProfileRepo.updateTouristProfile(
      id: id,
      firstName: firstName,
      lastName: lastName,
      country: country,
      whatsAppNumber: whatsAppNumber,
      imagePath: imagePath,
    );

    result.fold(
      (failure) => emit(TouristProfileFailure(failure.message)),
      (profile) => emit(
        TouristProfileUpdateSuccess(profile, 'Profile updated successfully'),
      ),
    );
  }
}
