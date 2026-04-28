import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_guide/core/services/google_auth_config.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ["email", "profile"],
    serverClientId: GoogleAuthConfig.serverClientId,
  );
  Future<String?> signIn() async {
    try {
      if (GoogleAuthConfig.requiresApplePlist) {
        throw Exception(
          'Google Sign-In on iOS/macOS needs GoogleService-Info.plist from Firebase.',
        );
      }

      final account = await googleSignIn.signIn();

      if (account == null) {
        debugPrint('❌ User cancelled Google Sign In');
        return null;
      }

      final auth = await account.authentication;

      // 👇 نربط بـ Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      // 👇 ده التوكن الصح
      final firebaseIdToken = await userCredential.user?.getIdToken();

      debugPrint("✅ Firebase ID Token: $firebaseIdToken");

      return firebaseIdToken;
    } catch (e) {
      debugPrint('❌ Error signing in with Google: $e');
      rethrow;
    }
  }

  // Future<String?> signIn() async {
  //   try {
  //     // await googleSignIn.disconnect();
  //     final account = await googleSignIn.signIn();

  //     if (account == null) {
  //       debugPrint('❌ User cancelled Google Sign In');
  //       return null;
  //     }

  //     final auth = await account.authentication;

  //     debugPrint('✅ Google Sign In successful');
  //     debugPrint('📧 Email: ${account.email}');
  //     debugPrint('👤 Name: ${account.displayName}');
  //     // debugPrint('🪪 ID Token: ${auth.idToken}');

  //     debugPrint("TOKEN LENGTH: ${auth.idToken?.length}");
  //     debugPrint("TOKEN: ${auth.idToken}");
  //     print("ID TOKEN: ${auth.idToken}");
  //     print("ACCESS TOKEN: ${auth.accessToken}");

  //     return auth.idToken;
  //   } catch (e) {
  //     debugPrint('❌ Error signing in with Google: $e');
  //     return null;
  //   }
  // }

  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      debugPrint('✅ Google Sign Out successful');
    } catch (e) {
      debugPrint('❌ Error signing out from Google: $e');
    }
  }

  Future<bool> isSignedIn() async {
    return await googleSignIn.isSignedIn();
  }

  GoogleSignInAccount? getCurrentUser() {
    return googleSignIn.currentUser;
  }
}
