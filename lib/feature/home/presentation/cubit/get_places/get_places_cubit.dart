import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/home/data/repo/get_places/get_places_repo.dart';
import 'package:smart_guide/feature/home/model/place_model.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_places/get_places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  PlacesCubit({required this.getPlacesRepo}) : super(PlacesInitial());

  final GetPlacesRepo getPlacesRepo;

  final List<PlaceModel> _allPlaces = [];

  List<PlaceModel> get places => _allPlaces;

  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasReachedMax = false;
  String _currentSearch = '';

  Future<void> getPlaces({bool loadMore = false, String? search}) async {
    // Prevent duplicate requests while loading or after reaching the end
    if (state is PlacesPaginationLoading || (loadMore && _hasReachedMax))
      return;

    // Update search term if provided
    if (search != null) {
      // Skip if searching the same term and not loading more
      if (_currentSearch == search && !loadMore) return;
      _currentSearch = search;
    } else if (!loadMore) {
      // Plain refresh call — clear any leftover search
      _currentSearch = '';
    }

    // Prepare state before fetching
    if (!loadMore) {
      emit(PlacesLoading());
      _currentPage = 1;
      _hasReachedMax = false;
      _allPlaces.clear();
    } else {
      emit(PlacesPaginationLoading());
    }

    final result = await getPlacesRepo.getPlaces(
      pageIndex: _currentPage,
      pageSize: _pageSize,
      search: _currentSearch,
    );

    result.fold(
      (failure) {
        if (loadMore) {
          // On pagination failure, preserve existing data instead of clearing
          emit(
            PlacesSuccess(
              places: List.from(_allPlaces),
              hasReachedMax: _hasReachedMax,
            ),
          );
        } else {
          emit(PlacesFailure(failure.message));
        }
      },
      (response) {
        final newPlaces = response.data;

        if (newPlaces.isEmpty) {
          _hasReachedMax = true;
        } else {
          _allPlaces.addAll(newPlaces);
          _currentPage++;

          // Check if we reached the total count from the API
          if (_allPlaces.length >= response.count) {
            _hasReachedMax = true;
          }
        }

        emit(
          PlacesSuccess(
            places: List.from(_allPlaces),
            hasReachedMax: _hasReachedMax,
          ),
        );
      },
    );
  }

  /// Searches places by query. Best used with a Debouncer from the UI.
  Future<void> searchPlaces(String value) async {
    await getPlaces(search: value);
  }

  /// Clears any previous search term and fetches the fresh default list.
  Future<void> refreshPlaces() async {
    _currentSearch = '';
    _currentPage = 1;
    _hasReachedMax = false;
    _allPlaces.clear();
    await getPlaces();
  }
}
