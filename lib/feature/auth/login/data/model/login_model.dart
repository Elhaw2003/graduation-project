import 'package:equatable/equatable.dart';

class LoginModel extends Equatable {
  final String? id;
  final String? message;
  final bool? isAuthanticated;
  final String? userName;
  final String? email;
  final String? country;
  final String? whatsAppNumber;
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
      isAuthanticated: json['isAuthanticated'],
      userName: json['userName'],
      email: json['email'],
      country: json['country'],
      whatsAppNumber: json['whatsAppNumber'],
      token: json['token'],
      refreshToken: json['refreshToken'],
      expiresOn: json['expiresOn'],
      refreshTokenExpiresOn: json['refreshTokenExpiresOn'],
      roles: json['roles'] != null ? List<String>.from(json['roles']) : null,
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
