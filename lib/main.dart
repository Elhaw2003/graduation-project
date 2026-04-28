import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/routing/routing_generation_config.dart';
import 'package:smart_guide/core/services/cache/cache_helper.dart';
import 'package:smart_guide/core/services/manage_cubit_servise.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/pick_image/pick_image_cubit.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();

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
      child: BlocProvider(
        create: (context) => PickImageCubit(),
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
