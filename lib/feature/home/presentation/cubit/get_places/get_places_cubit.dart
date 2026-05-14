import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/home/data/repo/get_places/get_places_repo.dart';
import 'package:smart_guide/feature/home/model/place_model.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_places/get_places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  PlacesCubit({required this.getPlacesRepo}) : super(PlacesInitial());

  final GetPlacesRepo getPlacesRepo;

  final List<PlaceModel> _allPlaces = [];

  // 👇 هذا هو السطر الناقص الذي يحل المشكلة
  List<PlaceModel> get places => _allPlaces;

  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasReachedMax = false;
  String _currentSearch = '';

  Future<void> getPlaces({bool loadMore = false, String? search}) async {
    // منع الطلبات المتكررة إذا كنا نحمل حالياً أو وصلنا للنهاية
    if (state is PlacesPaginationLoading || (loadMore && _hasReachedMax))
      return;

    // تحديث كلمة البحث إذا تم إرسالها
    if (search != null) {
      // إذا كان يبحث عن نفس الكلمة وهو ليس LoadMore، لا تفعل شيء
      if (_currentSearch == search && !loadMore) return;
      _currentSearch = search;
    }

    // تجهيز الحالة قبل البدء
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
          // إذا فشل الـ pagination، لا نمسح البيانات، بل نعيد الحالة الناجحة بالبيانات الحالية
          emit(
            PlacesSuccess(
              places: List.from(_allPlaces),
              hasReachedMax: _hasReachedMax,
            ),
          );
          // اختياري: يمكنك إرسال Trigger لعرض SnackBar هنا
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

          // التحقق إذا وصلنا للحد الأقصى بناءً على الـ count الراجع من الـ API
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

  /// دالة البحث: يفضل استدعاؤها مع Debouncer من الـ UI
  Future<void> searchPlaces(String value) async {
    await getPlaces(search: value);
  }

  /// دالة التحديث (Pull to Refresh)
  Future<void> refreshPlaces() async {
    await getPlaces(search: _currentSearch);
  }
}
