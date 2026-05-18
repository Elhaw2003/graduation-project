import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';

class SecureStorageHelper {
  // Singleton Pattern
  static final SecureStorageHelper instance = SecureStorageHelper.internal();
  factory SecureStorageHelper() => instance;
  SecureStorageHelper.internal();

  final storage = const FlutterSecureStorage();

  // Keys
  static const String accessTokenKey = 'token';
  static const String refreshTokenKey = 'refreshToken';
  static const String expiresAtKey = 'expiresOn';
  static const String refreshTokenExpiresOnKey = 'refreshTokenExpiresOn';
  static const String userTypeKey = 'userType';

  // Save tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String expiresAt,
    required String refreshTokenExpiresOn,
  }) async {
    await storage.write(key: accessTokenKey, value: accessToken);
    await storage.write(key: refreshTokenKey, value: refreshToken);
    await storage.write(key: expiresAtKey, value: expiresAt);
    await storage.write(
      key: refreshTokenExpiresOnKey,
      value: refreshTokenExpiresOn,
    );
  }

  /// 🔥 NEW
  Future<void> saveUserType(String userType) async {
    await storage.write(key: userTypeKey, value: userType);
  }

  Future<String?> getUserType() async {
    return await storage.read(key: userTypeKey);
  }

  static const String userNameKey = 'userName';
  static const String profilePicKey = 'profilePic';

  Future<void> saveUserData({
    required String userName,
    required String profilePic,
  }) async {
    await storage.write(key: userNameKey, value: userName);
    await storage.write(key: profilePicKey, value: profilePic);
  }

  Future<String?> getUserName() async {
    return await storage.read(key: userNameKey);
  }

  Future<String?> getProfilePic() async {
    return await storage.read(key: profilePicKey);
  }

  /// ✅ ROLE MAPPING (ADDED)
  Future<UserTypeEnum?> getUserTypeEnum() async {
    final value = await storage.read(key: userTypeKey);

    if (value == null) return null;

    if (value.toLowerCase() == "tourguide") {
      return UserTypeEnum.TourGuide;
    }

    return UserTypeEnum.Tourist;
  }

  // Get access token
  Future<String?> getAccessToken() async {
    return await storage.read(key: accessTokenKey);
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await storage.read(key: refreshTokenKey);
  }

  // Get expires at
  Future<String?> getExpiresAt() async {
    return await storage.read(key: expiresAtKey);
  }

  // Get refresh token expires at
  Future<String?> getRefreshTokenExpiresAt() async {
    return await storage.read(key: refreshTokenExpiresOnKey);
  }

  // Clear all tokens (Logout)
  Future<void> clearTokens() async {
    await storage.delete(key: accessTokenKey);
    await storage.delete(key: refreshTokenKey);
    await storage.delete(key: expiresAtKey);
    await storage.delete(key: refreshTokenExpiresOnKey);
    await storage.delete(key: userTypeKey);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
