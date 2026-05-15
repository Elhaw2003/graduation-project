import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/cache/cache_helper.dart';
import 'package:smart_guide/feature/home/model/place_model.dart';
import 'package:smart_guide/feature/saved/data/repo/saved_places_repo.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_states.dart';

const String kSavedPlaceIds = 'kSavedPlaceIds';

class SavedPlacesCubit extends Cubit<SavedPlacesState> {
  final SavedPlacesRepo savedPlacesRepo;

  SavedPlacesCubit({required this.savedPlacesRepo})
    : super(const SavedPlacesSuccess({}));

  /// ================= GET SAVED =================
  Future<void> getSavedPlaces() async {
    emit(SavedPlacesLoading());

    // Load locally cached ids first
    final cachedStr = CacheHelper.getString(kSavedPlaceIds);
    final Set<int> cachedIds = {};
    if (cachedStr != null && cachedStr.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(cachedStr);
        cachedIds.addAll(decoded.map((e) => e as int));
      } catch (_) {}
    }

    // Try fetching from API
    final result = await savedPlacesRepo.getSavedPlaces();

    result.fold((failure) {
      // If API fails, fallback to cached ids
      emit(SavedPlacesSuccess(cachedIds, places: []));
      emit(SavedPlacesFailure(failure.message));
    }, (
      places,
    ) {
      final ids = places.map((e) => e.id).toSet();

      // merge cached ids with API ids to avoid losing client-only saves
      final merged = <int>{}..addAll(cachedIds)..addAll(ids);

      // persist merged ids locally
      CacheHelper.setString(kSavedPlaceIds, jsonEncode(merged.toList()));

      emit(SavedPlacesSuccess(merged, places: places));
    });
  }

  /// ================= SAVE =================
  Future<void> savePlace({required int placeId}) async {
    final currentState = state;

    final currentIds = _getCurrentIds();
    final currentPlaces = _getCurrentPlaces();

    final updatedIds = Set<int>.from(currentIds)..add(placeId);

    /// optimistic update
    emit(SavedPlacesSuccess(updatedIds, places: currentPlaces));

    // Persist optimistic change locally immediately
    CacheHelper.setString(kSavedPlaceIds, jsonEncode(updatedIds.toList()));

    final result = await savedPlacesRepo.savePlace(placeId: placeId);

    result.fold(
      (failure) {
        // revert on failure
        emit(SavedPlacesSuccess(currentIds, places: currentPlaces));
        CacheHelper.setString(kSavedPlaceIds, jsonEncode(currentIds.toList()));
        emit(SavedPlacesFailure(failure.message));
      },
      (message) {
        // ensure persisted
        CacheHelper.setString(kSavedPlaceIds, jsonEncode(updatedIds.toList()));
        emit(SavePlaceSuccess(savedIds: updatedIds, message: message));
        emit(SavedPlacesSuccess(updatedIds, places: currentPlaces));
      },
    );
  }

  /// ================= REMOVE =================
  Future<void> removePlace({required int placeId}) async {
    final currentIds = _getCurrentIds();
    final currentPlaces = _getCurrentPlaces();

    final updatedIds = Set<int>.from(currentIds)..remove(placeId);
    final updatedPlaces = currentPlaces.where((p) => p.id != placeId).toList();

    /// optimistic update
    emit(SavedPlacesSuccess(updatedIds, places: updatedPlaces));

    // Persist optimistic change locally immediately
    CacheHelper.setString(kSavedPlaceIds, jsonEncode(updatedIds.toList()));

    final result = await savedPlacesRepo.removeSavedPlace(placeId: placeId);

    result.fold(
      (failure) {
        // revert on failure
        emit(SavedPlacesSuccess(currentIds, places: currentPlaces));
        CacheHelper.setString(kSavedPlaceIds, jsonEncode(currentIds.toList()));
        emit(SavedPlacesFailure(failure.message));
      },
      (message) {
        CacheHelper.setString(kSavedPlaceIds, jsonEncode(updatedIds.toList()));
        emit(RemovePlaceSuccess(savedIds: updatedIds, message: message));
        emit(SavedPlacesSuccess(updatedIds, places: updatedPlaces));
      },
    );
  }

  Set<int> _getCurrentIds() {
    final currentState = state;
    return currentState is SavedPlacesSuccess ? currentState.savedIds : {};
  }

  List<PlaceModel> _getCurrentPlaces() {
    final currentState = state;
    return currentState is SavedPlacesSuccess ? currentState.places : [];
  }
}
