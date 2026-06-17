import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/services/cache/tourist_profile_cache_sync.dart';
import 'package:smart_guide/feature/profile/data/model/tourist_profile_model.dart';
import 'package:smart_guide/feature/profile/presentation/cubit/tourist_session/tourist_session_states.dart';

class TouristSessionCubit extends Cubit<TouristSessionState> {
  TouristSessionCubit() : super(const TouristSessionInitial()) {
    register(this);
    loadFromCache();
  }

  static TouristSessionCubit? _activeInstance;

  static void register(TouristSessionCubit cubit) {
    _activeInstance = cubit;
  }

  @override
  Future<void> close() {
    if (_activeInstance == this) {
      _activeInstance = null;
    }
    return super.close();
  }

  Future<void> loadFromCache() async {
    final results = await Future.wait([
      SecureStorageHelper.instance.getUserName(),
      SecureStorageHelper.instance.getProfilePic(),
      SecureStorageHelper.instance.getUserId(),
    ]);

    emit(
      TouristSessionLoaded(
        userName: results[0] ?? '',
        profilePic: results[1],
        userId: results[2] ?? '',
      ),
    );
  }

  /// Persists fresh profile data and refreshes the active TouristApp session.
  static Future<void> notifyProfileUpdated(TouristProfileModel profile) async {
    await TouristProfileCacheSync.persist(profile);
    await _activeInstance?.loadFromCache();
  }
}
