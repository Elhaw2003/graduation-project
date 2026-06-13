import 'package:smart_guide/core/services/cache/cache_helper.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/all_guides/data/model/tour_guide_model.dart';

class GuideProfileCacheSync {
  GuideProfileCacheSync._();

  static Future<void> persist(TourGuideModel profile) async {
    final displayName = '${profile.firstName} ${profile.lastName}'.trim();
    final storage = SecureStorageHelper.instance;
    final email = await storage.getEmail() ?? profile.email;

    await storage.saveUserData(
      userName: displayName,
      profilePic: profile.profilePicture,
      userId: profile.userId,
      email: email,
      whatsAppNumber: profile.whatsAppNumber,
      country: profile.country,
    );

    await CacheHelper.setString(CacheHelper.kUserName, displayName);
    await CacheHelper.setString(CacheHelper.kUserImage, profile.profilePicture);
    await CacheHelper.setString(CacheHelper.kUserId, profile.userId);
  }
}
