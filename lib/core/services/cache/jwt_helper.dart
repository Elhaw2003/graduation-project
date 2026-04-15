import 'package:flutter/material.dart';

import 'package:jwt_decoder/jwt_decoder.dart';

class JwtHelper {
  static Map<String, dynamic>? decodeToken(String token) {
    try {
      if (JwtDecoder.isExpired(token)) {
        debugPrint('❌ Token is expired');
        return null;
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken;
    } catch (e) {
      debugPrint('❌ Error decoding token: $e');
      return null;
    }
  }

  static String? getUserName(String token) {
    final decoded = decodeToken(token);
    return decoded?['name'];
  }

  static String? getUserEmail(String token) {
    final decoded = decodeToken(token);
    return decoded?['email'];
  }

  static String? getUserId(String token) {
    final decoded = decodeToken(token);
    return decoded?['sub'];
  }

  static String? getUserRole(String token) {
    final decoded = decodeToken(token);
    return decoded?['roles'];
  }

  static String? getUserPicture(String token) {
    final decoded = decodeToken(token);
    return decoded?['picture'];
  }

  static bool isTokenValid(String token) {
    try {
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      debugPrint('❌ Error checking token validity: $e');
      return false;
    }
  }

  static DateTime? getExpirationDate(String token) {
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      debugPrint('❌ Error getting expiration date: $e');
      return null;
    }
  }

  // احصل على كل البيانات من الـ Token (للـ Debugging)
  static Map<String, dynamic>? getAllData(String token) {
    return decodeToken(token);
  }
}
