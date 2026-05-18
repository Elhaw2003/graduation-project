import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/cache/cache_helper.dart';
import 'package:smart_guide/feature/favorite/data/model/saved_guided_model.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/repo/save_guides/save_guides_repo.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/save_guides/save_guides_states.dart';

const String kSavedGuideIds = 'kSavedGuideIds';

class SavedGuidesCubit extends Cubit<SavedGuidesState> {
  final SavedGuidesRepository savedGuidesRepository;

  SavedGuidesCubit({required this.savedGuidesRepository})
    : super(const SavedGuidesSuccess({}));

  /// Load saved guides from local cache and remote API, merging both sources
  Future<void> getSavedGuides() async {
    final currentSavedIds = state.getSavedIds();
    emit(SavedGuidesLoading(savedIds: currentSavedIds));

    final cachedStr = CacheHelper.getString(kSavedGuideIds);
    final Set<String> cachedIds = {};
    if (cachedStr != null && cachedStr.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(cachedStr);
        cachedIds.addAll(decoded.map((e) => e as String));
      } catch (_) {}
    }

    final result = await savedGuidesRepository.getSavedGuides();

    result.fold(
      (failure) {
        emit(SavedGuidesSuccess(cachedIds, guides: const []));
        emit(
          SavedGuidesFailure(
            errorMessage: failure.message,
            savedIds: cachedIds,
          ),
        );
      },
      (guides) {
        final ids = guides.map((e) => e.guideId).toSet();
        final merged = <String>{}
          ..addAll(cachedIds)
          ..addAll(ids);

        CacheHelper.setString(kSavedGuideIds, jsonEncode(merged.toList()));
        emit(SavedGuidesSuccess(merged, guides: guides));
      },
    );
  }

  /// Save guide with optimistic update: emit immediately, call API, rollback on failure
  Future<void> saveGuide({required String guideId}) async {
    final currentIds = _getCurrentIds();
    final currentGuides = _getCurrentGuides();

    final updatedIds = Set<String>.from(currentIds)..add(guideId);

    // OPTIMISTIC: Emit immediately to show UI change instantly
    emit(SavedGuidesSuccess(updatedIds, guides: currentGuides));
    CacheHelper.setString(kSavedGuideIds, jsonEncode(updatedIds.toList()));

    final result = await savedGuidesRepository.saveGuide(guideId: guideId);

    result.fold(
      (failure) {
        // ROLLBACK: Revert to previous state on failure
        emit(SavedGuidesSuccess(currentIds, guides: currentGuides));
        CacheHelper.setString(kSavedGuideIds, jsonEncode(currentIds.toList()));
        emit(
          SavedGuidesFailure(
            errorMessage: failure.message,
            savedIds: currentIds,
          ),
        );
      },
      (message) {
        // SUCCESS: Emit message state then main success state
        emit(SaveGuideSuccess(savedIds: updatedIds, message: message));
        // CRITICAL: Re-emit main state with IDs to prevent flickering
        emit(SavedGuidesSuccess(updatedIds, guides: currentGuides));
      },
    );
  }

  /// Remove guide with optimistic update: emit immediately, call API, rollback on failure
  Future<void> removeGuide({required String guideId}) async {
    final currentIds = _getCurrentIds();
    final currentGuides = _getCurrentGuides();

    final updatedIds = Set<String>.from(currentIds)..remove(guideId);
    final updatedGuides = currentGuides
        .where((g) => g.guideId != guideId)
        .toList();

    // OPTIMISTIC: Emit immediately to show UI change instantly
    emit(SavedGuidesSuccess(updatedIds, guides: updatedGuides));
    CacheHelper.setString(kSavedGuideIds, jsonEncode(updatedIds.toList()));

    final result = await savedGuidesRepository.removeSavedGuide(
      guideId: guideId,
    );

    result.fold(
      (failure) {
        // ROLLBACK: Revert to previous state on failure
        emit(SavedGuidesSuccess(currentIds, guides: currentGuides));
        CacheHelper.setString(kSavedGuideIds, jsonEncode(currentIds.toList()));
        emit(
          SavedGuidesFailure(
            errorMessage: failure.message,
            savedIds: currentIds,
          ),
        );
      },
      (message) {
        // SUCCESS: Emit message state then main success state
        emit(RemoveGuideSuccess(savedIds: updatedIds, message: message));
        // CRITICAL: Re-emit main state with IDs to prevent flickering
        emit(SavedGuidesSuccess(updatedIds, guides: updatedGuides));
      },
    );
  }

  Set<String> _getCurrentIds() {
    return state.getSavedIds();
  }

  List<SavedGuideModel> _getCurrentGuides() {
    final currentState = state;
    return currentState is SavedGuidesSuccess ? currentState.guides : const [];
  }
}
