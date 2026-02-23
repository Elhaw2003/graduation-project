import 'package:easy_localization/easy_localization.dart';
import 'package:smart_guide/feature/onboarding/data/model/onboarding_model.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

List<OnboardingModel> onboardings = [
  OnboardingModel(
    image: Assets.imagesPngFirstSplashScreen,
    title: LocaleKeys.exploreEgyptHistory.tr(),
    description: LocaleKeys.discoverAncientSecrets.tr(),
    buttonText: LocaleKeys.next.tr(),
  ),
  OnboardingModel(
    image: Assets.imagesPngSecondSplashScreen,
    title: LocaleKeys.yourJourneyStartsHere.tr(),
    description: LocaleKeys.planYourTrip.tr(),
    buttonText: LocaleKeys.next.tr(),
  ),
  OnboardingModel(
    image: Assets.imagesPngThirdSplashScreen,
    title: LocaleKeys.exploreEgyptSmartWay.tr(),
    description: LocaleKeys.smartGuideEgypt.tr(),
    buttonText: LocaleKeys.discoverEgypt.tr(),
  ),
];
