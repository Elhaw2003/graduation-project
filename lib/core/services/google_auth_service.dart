import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ["email", "profile"],
    // clientId:
    //     "919550202879-8eq161ednr5s8o9qg18r8ht48gtgo496.apps.googleusercontent.com",
    // // "919550202879-l111l25c7s01ss2sa71i75ha0gp0dkmc.apps.googleusercontent.com",
  );
  Future<String?> signIn() async {
    try {
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
      return null;
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
