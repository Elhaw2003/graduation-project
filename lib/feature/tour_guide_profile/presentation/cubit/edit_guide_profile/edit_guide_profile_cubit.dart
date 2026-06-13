import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/guid_app/presentation/cubit/guide_session/guide_session_cubit.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/repo/edit_guide_profile/edit_guide_profile_repo.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/edit_guide_profile/edit_guide_profile_states.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';
class EditGuideProfileCubit extends Cubit<EditGuideProfileState> {
  final EditGuideProfileRepo repository;

  EditGuideProfileCubit({required this.repository})
      : super(EditGuideProfileInitial());

  Future<void> updateGuideProfile({
    required String id,
    required String firstName,
    required String lastName,
    required String country,
    required String whatsAppNumber,
    required String bio,
    required double pricePerDay,
    required List<String> cities,
    required List<String> languages,
    String? profilePicturePath,
    List<String>? retainedGalleryUrls,
    List<String>? newGalleryPaths,
  }) async {
    emit(EditGuideProfileLoading());

    final result = await repository.updateGuideProfile(
      id: id,
      firstName: firstName,
      lastName: lastName,
      country: country,
      whatsAppNumber: whatsAppNumber,
      bio: bio,
      pricePerDay: pricePerDay,
      cities: cities,
      languages: languages,
      profilePicturePath: profilePicturePath,
      retainedGalleryUrls: retainedGalleryUrls,
      newGalleryPaths: newGalleryPaths,
    );

    await result.fold(
      (failure) async {
        emit(EditGuideProfileFailure(errorMessage: failure.message));
      },
      (profile) async {
        await GuideSessionCubit.notifyProfileUpdated(profile);
        if (isClosed) return;
        emit(
          EditGuideProfileSuccess(
            profile: profile,
            message: LocaleKeys.updateSuccess.tr(),
          ),
        );
      },
    );
  }
}