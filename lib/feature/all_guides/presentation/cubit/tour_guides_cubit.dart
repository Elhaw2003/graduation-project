import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/all_guides/data/repo/tour_guides_repo.dart';
import 'package:smart_guide/feature/all_guides/presentation/cubit/tour_guides_states.dart';

class TourGuidesCubit extends Cubit<TourGuidesState> {
  final TourGuidesRepository repository;

  TourGuidesCubit({required this.repository}) : super(TourGuidesInitial());

  Future<void> fetchTourGuides() async {
    emit(TourGuidesLoading());
    final result = await repository.getTourGuides();
    result.fold(
      (failure) => emit(TourGuidesFailure(errorMessage: failure.message)),
      (tourGuides) => emit(TourGuidesSuccess(tourGuides: tourGuides)),
    );
  }

  Future<void> fetchTourGuideProfile(String id) async {
    emit(TourGuidesLoading());
    final result = await repository.getTourGuideProfile(id);
    result.fold(
      (failure) => emit(TourGuidesFailure(errorMessage: failure.message)),
      (tourGuide) => emit(GuideDetailsSuccess(tourGuide: tourGuide)),
    );
  }
}
