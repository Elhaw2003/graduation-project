// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/png
  $AssetsImagesPngGen get png => const $AssetsImagesPngGen();

  /// Directory path: assets/images/svg
  $AssetsImagesSvgGen get svg => const $AssetsImagesSvgGen();
}

class $AssetsLottieGen {
  const $AssetsLottieGen();

  /// File path: assets/lottie/done.json
  String get done => 'assets/lottie/done.json';

  /// List of all assets
  List<String> get values => [done];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/ar.json
  String get ar => 'assets/translations/ar.json';

  /// File path: assets/translations/en.json
  String get en => 'assets/translations/en.json';

  /// List of all assets
  List<String> get values => [ar, en];
}

class $AssetsImagesPngGen {
  const $AssetsImagesPngGen();

  /// File path: assets/images/png/default_user_avatar.png
  AssetGenImage get defaultUserAvatar =>
      const AssetGenImage('assets/images/png/default_user_avatar.png');

  /// File path: assets/images/png/first_splash_screen.png
  AssetGenImage get firstSplashScreen =>
      const AssetGenImage('assets/images/png/first_splash_screen.png');

  /// File path: assets/images/png/logo_with_text.png
  AssetGenImage get logoWithText =>
      const AssetGenImage('assets/images/png/logo_with_text.png');

  /// File path: assets/images/png/logo_without_text.png
  AssetGenImage get logoWithoutText =>
      const AssetGenImage('assets/images/png/logo_without_text.png');

  /// File path: assets/images/png/second_splash_screen.png
  AssetGenImage get secondSplashScreen =>
      const AssetGenImage('assets/images/png/second_splash_screen.png');

  /// File path: assets/images/png/sphinx.jpg
  AssetGenImage get sphinx =>
      const AssetGenImage('assets/images/png/sphinx.jpg');

  /// File path: assets/images/png/subtract.png
  AssetGenImage get subtract =>
      const AssetGenImage('assets/images/png/subtract.png');

  /// File path: assets/images/png/third_splash_screen.png
  AssetGenImage get thirdSplashScreen =>
      const AssetGenImage('assets/images/png/third_splash_screen.png');

  /// File path: assets/images/png/valley _of_the_kings.png
  AssetGenImage get valleyOfTheKings =>
      const AssetGenImage('assets/images/png/valley _of_the_kings.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    defaultUserAvatar,
    firstSplashScreen,
    logoWithText,
    logoWithoutText,
    secondSplashScreen,
    sphinx,
    subtract,
    thirdSplashScreen,
    valleyOfTheKings,
  ];
}

class $AssetsImagesSvgGen {
  const $AssetsImagesSvgGen();

  /// File path: assets/images/svg/ai_icon.svg
  String get aiIcon => 'assets/images/svg/ai_icon.svg';

  /// File path: assets/images/svg/airplane.svg
  String get airplane => 'assets/images/svg/airplane.svg';

  /// File path: assets/images/svg/compass.svg
  String get compass => 'assets/images/svg/compass.svg';

  /// File path: assets/images/svg/explor_icon.svg
  String get explorIcon => 'assets/images/svg/explor_icon.svg';

  /// File path: assets/images/svg/guides_icon.svg
  String get guidesIcon => 'assets/images/svg/guides_icon.svg';

  /// File path: assets/images/svg/home_icon.svg
  String get homeIcon => 'assets/images/svg/home_icon.svg';

  /// File path: assets/images/svg/more_icon.svg
  String get moreIcon => 'assets/images/svg/more_icon.svg';

  /// File path: assets/images/svg/person.svg
  String get person => 'assets/images/svg/person.svg';

  /// File path: assets/images/svg/robot.svg
  String get robot => 'assets/images/svg/robot.svg';

  /// File path: assets/images/svg/settings.svg
  String get settings => 'assets/images/svg/settings.svg';

  /// List of all assets
  List<String> get values => [
    aiIcon,
    airplane,
    compass,
    explorIcon,
    guidesIcon,
    homeIcon,
    moreIcon,
    person,
    robot,
    settings,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottieGen lottie = $AssetsLottieGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
