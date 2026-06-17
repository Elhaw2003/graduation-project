import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/cache/guide_profile_cache_sync.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/all_guides/data/model/tour_guide_model.dart';
import 'package:smart_guide/feature/guid_app/presentation/cubit/guide_session/guide_session_states.dart';

class GuideSessionCubit extends Cubit<GuideSessionState> {
  GuideSessionCubit() : super(const GuideSessionInitial()) {
    loadFromCache();
  }

  static GuideSessionCubit? _activeInstance;

  static void register(GuideSessionCubit cubit) {
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
      GuideSessionLoaded(
        userName: (results[0] as String?) ?? '',
        profilePic: results[1] as String?,
        userId: (results[2] as String?) ?? '',
      ),
    );
  }

  /// Persists fresh profile data and refreshes the active GuideApp session.
  static Future<void> notifyProfileUpdated(TourGuideModel profile) async {
    await GuideProfileCacheSync.persist(profile);
    await _activeInstance?.loadFromCache();
  }
}
