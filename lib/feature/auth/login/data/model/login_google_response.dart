import 'package:equatable/equatable.dart';

class LoginGoogleResponseModel extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String expiresOn;
  final String refreshTokenExpiresOn;

  const LoginGoogleResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresOn,
    required this.refreshTokenExpiresOn,
  });

  factory LoginGoogleResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginGoogleResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresOn: json['expiresOn'] as String,
      refreshTokenExpiresOn: json['refreshTokenExpiresOn'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'expiresOn': expiresOn,
    'refreshTokenExpiresOn': refreshTokenExpiresOn,
  };

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    expiresOn,
    refreshTokenExpiresOn,
  ];
}
