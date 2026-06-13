import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/services/cache/tourist_profile_cache_sync.dart';
import 'package:smart_guide/feature/profile/data/model/tourist_profile_model.dart';
import 'package:smart_guide/feature/profile/presentation/cubit/tourist_session/tourist_session_states.dart';

class TouristSessionCubit extends Cubit<TouristSessionState> {
  TouristSessionCubit() : super(const TouristSessionInitial()) {
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
    final userName = await SecureStorageHelper.instance.getUserName();
    final profilePic = await SecureStorageHelper.instance.getProfilePic();
    final userId = await SecureStorageHelper.instance.getUserId();

    emit(
      TouristSessionLoaded(
        userName: userName ?? '',
        profilePic: profilePic,
        userId: userId ?? '',
      ),
    );
  }

  /// Persists fresh profile data and refreshes the active TouristApp session.
  static Future<void> notifyProfileUpdated(TouristProfileModel profile) async {
    await TouristProfileCacheSync.persist(profile);
    await _activeInstance?.loadFromCache();
  }
}
