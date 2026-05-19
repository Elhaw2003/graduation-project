import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/book_now/data/model/tour_model.dart';
import 'tours_repository.dart';

part 'tours_state.dart';
class ToursCubit extends Cubit<ToursState> {
  final ToursRepository repository;

  ToursCubit(this.repository) : super(ToursInitial());

  List<TourModel> tours = [];

  Future<void> getTours() async {
    emit(ToursLoading());

    try {
      tours = await repository.getTours();
      emit(ToursSuccess(tours));
    } catch (e) {
      emit(ToursFailure(e.toString()));
    }
  }
}
