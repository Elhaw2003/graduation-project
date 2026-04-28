import 'package:flutter/foundation.dart';

class GoogleAuthConfig {
  GoogleAuthConfig._();

  // Web OAuth client from Firebase project settings. It is required so Google
  // Sign-In returns a usable ID token for the backend `Auth/google-login` API.
  static const String serverClientId =
      '550908208870-8p9ph0rcl7du5crr59e53eesrkbj4k90.apps.googleusercontent.com';

  static bool get requiresApplePlist =>
      !kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);
}
