class EndPoint {
  static String baseUrl = "https://smartguide.runasp.net/api/";
  static String register = "Auth/register";
  static String login = "Auth/login";
  static String refreshToken = "Auth/refreshtoken";
  static String addRole = "Auth/addRole";
  static String forgotPassword = "Auth/forgot-password";
  static String resendOtp = "Auth/send-reset-otp";
  static String verifyCode = "Auth/verify-reset-otp";
  static String newPassword = "Auth/reset-password";
  static String googleSignIn = "Auth/google-login";
  static String logout = "Auth/logout";
  static String getPlaces = "places";
  static String getPlaceDetails ({required String id})=> "places/$id";
}

class ApiKey {
  static const String statusCode = "statusCode";
  static const String message = "message";
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String email = "email";
  static const String username = "username";
  static const String phone = "phone";
  static const String password = "password";
  static const String image = "image";
  static const String token = "token";
  static const String refreshToken = "refreshToken";
  static const String id = "id";
  static const String name = "name";
  static const String confirmPassword = "confirmPassword";
  static const String location = "location";
  static const String idToken = "idToken";

  /// Authentication token prefix for Bearer-style authentication
  static const String tokenPrefix = "Bearer";
}
