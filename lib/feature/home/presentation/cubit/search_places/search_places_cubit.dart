import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/home/data/repo/get_places/get_places_repo.dart';
import 'package:smart_guide/feature/home/model/place_model.dart';
import 'package:smart_guide/feature/home/presentation/cubit/search_places/search_places_state.dart';

/// A dedicated cubit for the SearchPlacesScreen that is completely
/// isolated from the main [PlacesCubit] used by HomeBody and
/// PopularPlacesScreen. This prevents search queries from leaking
/// into the main list state.
class SearchPlacesCubit extends Cubit<SearchPlacesState> {
  SearchPlacesCubit({required this.getPlacesRepo})
      : super(SearchPlacesInitial());

  final GetPlacesRepo getPlacesRepo;

  final List<PlaceModel> _results = [];

  List<PlaceModel> get results => _results;

  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasReachedMax = false;
  String _currentSearch = '';

  Future<void> searchPlaces(String value) async {
    if (value.trim().isEmpty) {
      _results.clear();
      _currentSearch = '';
      _currentPage = 1;
      _hasReachedMax = false;
      emit(SearchPlacesInitial());
      return;
    }

    // New search term — reset everything
    if (_currentSearch != value) {
      _currentSearch = value;
      _currentPage = 1;
      _hasReachedMax = false;
      _results.clear();
      emit(SearchPlacesLoading());
    }

    if (_hasReachedMax) return;

    final result = await getPlacesRepo.getPlaces(
      pageIndex: _currentPage,
      pageSize: _pageSize,
      search: _currentSearch,
    );

    result.fold(
      (failure) {
        emit(SearchPlacesFailure(failure.message));
      },
      (response) {
        final newPlaces = response.data;

        if (newPlaces.isEmpty) {
          _hasReachedMax = true;
        } else {
          _results.addAll(newPlaces);
          _currentPage++;

          if (_results.length >= response.count) {
            _hasReachedMax = true;
          }
        }

        emit(
          SearchPlacesSuccess(
            places: List.from(_results),
            hasReachedMax: _hasReachedMax,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (_hasReachedMax ||
        state is SearchPlacesPaginationLoading ||
        _currentSearch.isEmpty) {
      return;
    }

    emit(SearchPlacesPaginationLoading());

    final result = await getPlacesRepo.getPlaces(
      pageIndex: _currentPage,
      pageSize: _pageSize,
      search: _currentSearch,
    );

    result.fold(
      (failure) {
        // On pagination failure, restore the successful state
        emit(
          SearchPlacesSuccess(
            places: List.from(_results),
            hasReachedMax: _hasReachedMax,
          ),
        );
      },
      (response) {
        final newPlaces = response.data;

        if (newPlaces.isEmpty) {
          _hasReachedMax = true;
        } else {
          _results.addAll(newPlaces);
          _currentPage++;

          if (_results.length >= response.count) {
            _hasReachedMax = true;
          }
        }

        emit(
          SearchPlacesSuccess(
            places: List.from(_results),
            hasReachedMax: _hasReachedMax,
          ),
        );
      },
    );
  }
}
