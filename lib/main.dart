import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/core/routing/routing_generation_config.dart';
import 'package:smart_guide/core/services/cache/cache_helper.dart';
import 'package:smart_guide/core/services/manage_cubit_servise.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_constants.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/pick_image/pick_image_cubit.dart';
import 'package:smart_guide/feature/home/data/repo/get_places/get_places_repo_imple.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_places/get_places_cubit.dart';
import 'package:smart_guide/feature/saved/data/repo/saved_places_repo_imple.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_cubit.dart';
import 'package:smart_guide/feature/settings/data/repo/log_out/log_out_repo_imple.dart';
import 'package:smart_guide/feature/settings/presentation/cubit/log_out/cubit/log_out_cubit.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/repo/save_guides/save_guides_repo_imple.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/save_guides/save_guides_cubit.dart';
import 'package:smart_guide/feature/profile/data/repo/tourist_profile_repo_impl.dart';
import 'package:smart_guide/feature/profile/presentation/cubit/tourist_profile_cubit.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );
  Bloc.observer = MyBlocObserver();
  Stripe.publishableKey = AppConstants.publishableKey;

  /// hide status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  // make device vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => PickImageCubit()),
          BlocProvider(
            create: (context) => LogOutCubit(
              logOutRepo: LogOutRepoImple(apiConsumer: DioConsumer(dio: Dio())),
            ),
          ),
          BlocProvider(
            create: (context) => PlacesCubit(
              getPlacesRepo: GetPlacesRepoImple(
                apiConsumer: DioConsumer(dio: Dio()),
              ),
            )..getPlaces(),
          ),
          BlocProvider(
            create: (context) => SavedPlacesCubit(
              savedPlacesRepo: SavedPlacesRepoImpl(
                apiConsumer: DioConsumer(dio: Dio()),
              ),
            )..getSavedPlaces(),
          ),
          BlocProvider(
            create: (context) => SavedGuidesCubit(
              savedGuidesRepository: SavedGuidesRepositoryImpl(
                apiConsumer: DioConsumer(dio: Dio()),
              ),
            )..getSavedGuides(),
          ),
          BlocProvider(
            create: (context) => TouristProfileCubit(
              touristProfileRepo: TouristProfileRepoImpl(
                apiConsumer: DioConsumer(dio: Dio()),
              ),
            ),
          ),
        ],
        child: SmartGuide(),
      ),
    ),
  );
}

class SmartGuide extends StatelessWidget {
  const SmartGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          theme: ThemeData(scaffoldBackgroundColor: AppColors.backgroundColor),
          title: LocaleKeys.appName.tr(),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: RoutingGenerationConfig.routerGeneratorConfig,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
