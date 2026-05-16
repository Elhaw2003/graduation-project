import 'package:equatable/equatable.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';

class LoginModel extends Equatable {
  final String? id;
  final String? message;
  final bool? isAuthanticated;
  final String? userName;
  final String? email;
  final String? country;
  final String? whatsAppNumber;
  final String? profilePictureUrl;
  final String? token;
  final String? refreshToken;
  final String? expiresOn;
  final String? refreshTokenExpiresOn;
  final List<String>? roles;
  final bool? isGuideVerified;

  const LoginModel({
    this.id,
    this.message,
    this.isAuthanticated,
    this.userName,
    this.email,
    this.country,
    this.whatsAppNumber,
    this.profilePictureUrl,
    this.token,
    this.refreshToken,
    this.expiresOn,
    this.refreshTokenExpiresOn,
    this.roles,
    this.isGuideVerified,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'],
      message: json['message'],
      isAuthanticated: json['isAuthenticated'], // 🔥 fixed spelling
      userName: json['userName'],
      email: json['email'],
      country: json['country'],
      whatsAppNumber: json['whatsAppNumber'],
      profilePictureUrl: json['profilePictureUrl'],
      token: json['token'],
      refreshToken: json['refreshToken'],
      expiresOn: json['expiresOn'],
      refreshTokenExpiresOn: json['refreshTokenExpiresOn'],
      roles: json['roles'] != null ? List<String>.from(json['roles']) : null,
      isGuideVerified: json['isGuideVerified'],
    );
  }

  /// 🔥 SAFE ROLE MAPPING
  UserTypeEnum get userType {
    final role = (roles != null && roles!.isNotEmpty)
        ? roles!.first.toLowerCase().replaceAll('_', '')
        : null;

    if (role == "tourguide") {
      return UserTypeEnum.TourGuide;
    }

    return UserTypeEnum.Tourist;
  }

  @override
  List<Object?> get props => [
    id,
    message,
    isAuthanticated,
    userName,
    email,
    country,
    whatsAppNumber,
    token,
    refreshToken,
    expiresOn,
    refreshTokenExpiresOn,
    roles,
    isGuideVerified,
  ];
}
