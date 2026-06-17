import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/home/data/repo/get_place_detail/get_place_datail_repo.dart';
import 'package:smart_guide/feature/home/data/model/place_model.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_place_details/get_place_details_state.dart';

class GetPlaceDetailsCubit extends Cubit<GetPlaceDetailsState> {
  GetPlaceDetailsCubit({required this.getPlaceDetailsRepo})
    : super(GetPlaceDetailsInitial());

  final GetPlaceDatailRepo getPlaceDetailsRepo;

  /// Holds the last successfully loaded place so rating states don't clear the UI.
  PlaceModel? lastPlace;

  Future<void> getPlaceDetails({required String placeId}) async {
    emit(GetPlaceDetailsLoading());

    final result = await getPlaceDetailsRepo.getPlaceDetails(placeId: placeId);

    result.fold(
      (failure) {
        emit(GetPlaceDetailsFailure(errorMessage: failure.message));
      },
      (place) {
        lastPlace = place;
        emit(GetPlaceDetailsSuccess(place: place));
      },
    );
  }

  Future<void> ratePlace({
    required String placeId,
    required int rating,
    String? review,
  }) async {
    emit(RatePlaceLoading());
    final result = await getPlaceDetailsRepo.ratePlace(
      placeId: placeId,
      rating: rating,
      review: review,
    );
    result.fold(
      (failure) => emit(RatePlaceFailure(errorMessage: failure.message)),
      (message) => emit(RatePlaceSuccess(message: message)),
    );
  }
}
