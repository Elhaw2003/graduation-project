import 'package:equatable/equatable.dart';

class RegisterRequestModel extends Equatable {
  final String firstName;
  final String lastName;
  final String userName;
  final String country;
  final String email;
  final String? whatsAppNumber;
  final String password;
  final String confirmPassword;
  final String role;
  final String? profileImage;
  final String? guideLicenseImage;
  final String? nationalIdImage;

  const RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.country,
    required this.email,
    this.whatsAppNumber,
    required this.password,
    required this.confirmPassword,
    required this.role,
    this.profileImage,
    this.guideLicenseImage,
    this.nationalIdImage,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    userName,
    country,
    email,
    whatsAppNumber,
    password,
    confirmPassword,
    role,
    profileImage,
    guideLicenseImage,
    nationalIdImage,
  ];

  Map<String, dynamic> toJson() {
    return {
      "FirstName": firstName,
      "LastName": lastName,
      "UserName": userName,
      "Country": country,
      "Email": email,
      "WhatsAppNumber": whatsAppNumber,
      "Password": password,
      "ConfirmPassword": confirmPassword,
      "Role": role,
      "ProfileImage": profileImage,
      "GuideLicenseImage": guideLicenseImage,
      "NationalIdImage": nationalIdImage,
    };
  }
}
