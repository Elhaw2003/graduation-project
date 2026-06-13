import 'package:smart_guide/core/services/cache/cache_helper.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/profile/data/model/tourist_profile_model.dart';

class TouristProfileCacheSync {
  TouristProfileCacheSync._();

  static Future<void> persist(TouristProfileModel profile) async {
    final displayName = profile.fullName.isNotEmpty
        ? profile.fullName
        : profile.userName;
    final storage = SecureStorageHelper.instance;
    final email = await storage.getEmail() ?? profile.email;

    await storage.saveUserData(
      userName: displayName,
      profilePic: profile.touristImage,
      userId: profile.userId,
      email: email,
      whatsAppNumber: profile.whatsAppNumber,
      country: profile.country,
    );

    await CacheHelper.setString(CacheHelper.kUserName, displayName);
    await CacheHelper.setString(CacheHelper.kUserImage, profile.touristImage);
    await CacheHelper.setString(CacheHelper.kUserId, profile.userId);
  }
}
