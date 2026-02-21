import 'package:easy_localization/easy_localization.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.emailRequired.tr();
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
      caseSensitive: false,
    );

    if (!emailRegex.hasMatch(value)) {
      return LocaleKeys.emailInvalid.tr();
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.passwordRequired.tr();
    }

    if (value.length < 8) {
      return LocaleKeys.passwordMinLength.tr();
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return LocaleKeys.passwordUppercase.tr();
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return LocaleKeys.passwordLowercase.tr();
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return LocaleKeys.passwordNumber.tr();
    }

    return null;
  }

  static String? validateRetypePassword(
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.retypePasswordRequired.tr();
    }

    if (value != originalPassword) {
      return LocaleKeys.passwordsNotMatch.tr();
    }

    final passwordValidation = validatePassword(value);
    if (passwordValidation != null) return passwordValidation;

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.nameRequired.tr();
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 3) {
      return LocaleKeys.nameMinLength.tr();
    }

    // يدعم عربي + إنجليزي + مسافات فقط
    final nameRegex = RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$');

    if (!nameRegex.hasMatch(trimmedValue)) {
      return LocaleKeys.nameInvalid.tr();
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.phoneRequired.tr();
    }

    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    if (!phoneRegex.hasMatch(value)) {
      return LocaleKeys.phoneInvalid.tr();
    }

    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.otpRequired.tr();
    }

    final otpRegex = RegExp(r'^\d{6}$');

    if (!otpRegex.hasMatch(value)) {
      return LocaleKeys.otpInvalid.tr();
    }

    if (value.length != 6) {
      return LocaleKeys.otpLength.tr();
    }

    return null;
  }

  static String? validateNationalId(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.idRequired.tr();
    }

    if (!RegExp(r'^\d{14}$').hasMatch(value)) {
      return LocaleKeys.idInvalid.tr();
    }

    // التحقق من القرن
    final century = value[0];
    if (century != '2' && century != '3') {
      return LocaleKeys.idInvalid.tr();
    }

    // استخراج تاريخ الميلاد
    final year = int.parse(value.substring(1, 3));
    final month = int.parse(value.substring(3, 5));
    final day = int.parse(value.substring(5, 7));

    int fullYear;
    if (century == '2') {
      fullYear = 1900 + year;
    } else {
      fullYear = 2000 + year;
    }

    try {
      DateTime(fullYear, month, day);
    } catch (_) {
      return LocaleKeys.idInvalid.tr();
    }

    return null;
  }
}
