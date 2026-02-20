// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> _ar = {
    "exploreEgyptHistory": "اكتشف التاريخ العظيم لمصر",
    "discoverAncientSecrets":
        "من الأهرامات إلى المعابد... اكتشف أسرار الحضارة القديمة بطريقة ذكية.",
    "yourJourneyStartsHere": "رحلتك تبدأ من هنا",
    "planYourTrip":
        "خطط رحلتك بسهولة واكتشف أفضل المعالم السياحية والمطاعم والفنادق القريبة منك.",
    "exploreEgyptSmartWay": "استكشف مصر بطريقة ذكية",
    "smartGuideEgypt":
        "SmartGuide Egypt - رفيقك الذكي لاستكشاف مصر في كل مكان.",
    "next": "التالي",
    "discoverEgypt": "اكتشف مصر",
    "appName": "المرشد الزكي",
    "tourist": "مرشد سياحي",
    "guide": "دليل سياحي",
  };
  static const Map<String, dynamic> _en = {
    "exploreEgyptHistory": "Explore Egypt's Great History",
    "discoverAncientSecrets":
        "From pyramids to temples... uncover the secrets of ancient civilization the smart way.",
    "yourJourneyStartsHere": "Your Journey Starts Here",
    "planYourTrip":
        "Plan your trip easily and discover top attractions, restaurants, and hotels near you.",
    "exploreEgyptSmartWay": "Explore Egypt the Smart Way",
    "smartGuideEgypt":
        "SmartGuide Egypt - your intelligent companion to explore Egypt everywhere.",
    "next": "Next",
    "discoverEgypt": "Discover Egypt",
    "appName": "Smart Guide",
    "egypt": "Egypt",
    "tourist": "Tourist",
    "guide": "Guide",
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "ar": _ar,
    "en": _en,
  };
}
