import 'package:equatable/equatable.dart';

class RegisterResponseModel extends Equatable {
  final String id;
  final String message;
  final bool isAuthanticated;
  final String userName;
  final String email;
  final String country;
  final String whatsAppNumber;
  final String token;
  final String refreshToken;
  final String expiresOn;
  final String refreshTokenExpiresOn;
  final List<String> roles;
  final bool isGuideVerified;

  const RegisterResponseModel({
    required this.id,
    required this.message,
    required this.isAuthanticated,
    required this.userName,
    required this.email,
    required this.country,
    required this.whatsAppNumber,
    required this.token,
    required this.refreshToken,
    required this.expiresOn,
    required this.refreshTokenExpiresOn,
    required this.roles,
    required this.isGuideVerified,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      id: json['id'],
      message: json['message'],
      isAuthanticated: json['isAuthanticated'],
      userName: json['userName'],
      email: json['email'],
      country: json['country'],
      whatsAppNumber: json['whatsAppNumber'],
      token: json['token'],
      refreshToken: json['refreshToken'],
      expiresOn: json['expiresOn'],
      refreshTokenExpiresOn: json['refreshTokenExpiresOn'],
      roles: List<String>.from(json['roles']),
      isGuideVerified: json['isGuideVerified'],
    );
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
