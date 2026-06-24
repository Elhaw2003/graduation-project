import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/methods/custom_animated_snack_bar.dart';
import 'package:smart_guide/core/methods/input_validator.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/services/cache/cache_helper.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/shared_widgets/custom_rich_text_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/login/presentation/cubit/login_with_google/login_with_google_cubit.dart';
import 'package:smart_guide/feature/auth/login/presentation/cubit/login_with_google/login_with_google_states.dart';
import 'package:smart_guide/feature/auth/login/presentation/cubit/login_email/login_with_email_cubit.dart';
import 'package:smart_guide/feature/auth/login/presentation/cubit/login_email/login_with_email_states.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/widget/google_button.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/widget/login_button_widget.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/widget/remember_and_forgot_wiget.dart';
import 'package:smart_guide/feature/notifications/data/services/fcm_service.dart';
import 'package:smart_guide/feature/notifications/data/services/notification_service.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});
  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isRememberMeChecked = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) async {
        if (state is LoginSuccessStates) {
          debugPrint("🟢 LOGIN SUCCESS DETECTED");

          final fcmService = FcmService();

          final userType = state.loginModel.userType;
          debugPrint("👤 UserType: ${userType.name}");

          await SecureStorageHelper.instance.saveUserType(userType.name);
          debugPrint("💾 UserType saved to secure storage");

          CacheHelper.setBool(CacheHelper.kIsRememberMe, isRememberMeChecked);
          debugPrint("💾 RememberMe saved: $isRememberMeChecked");

          /// 1. Get FCM Token
          debugPrint("📲 Getting FCM device token...");
          final deviceToken = await fcmService.getDeviceToken();

          if (deviceToken == null) {
            debugPrint("❌ FCM TOKEN = NULL (Firebase issue)");
          } else {
            debugPrint("✅ FCM TOKEN GENERATED:");
            debugPrint(deviceToken);
          }

          /// 2. Get Auth Token
          final authToken = CacheHelper.kToken;

          if (authToken == null) {
            debugPrint("❌ AUTH TOKEN = NULL (cache issue)");
          } else {
            debugPrint("🔐 AUTH TOKEN FOUND");
          }

          /// 3. Send to backend
          if (deviceToken != null && authToken != null) {
            debugPrint("🚀 START SENDING FCM TO BACKEND...");

            final dio = Dio();

            dio.options.headers = {
              'Authorization': 'Bearer $authToken',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            };

            final notificationService = NotificationService(dio);

            try {
              final response = await notificationService.saveFcmToken(
                deviceToken,
              );

              debugPrint("📡 FCM API CALLED SUCCESSFULLY");
              debugPrint("📡 STATUS CODE: ${response.statusCode}");
              debugPrint("📡 RESPONSE DATA: ${response.data}");
            } catch (e) {
              debugPrint("❌ FCM API ERROR:");
              debugPrint(e.toString());
            }
          } else {
            debugPrint("⚠️ SKIPPED SENDING FCM (missing token)");
          }

          /// 4. Navigation trace
          debugPrint("➡️ Navigating after login...");

          CacheHelper.setBool(CacheHelper.kIsRememberMe, isRememberMeChecked);
          CustomAnimatedShowSnackBar.successSnackBar(
            context: context,
            message: LocaleKeys.loginSuccessfully.tr(),
          );

          Future.delayed(const Duration(seconds: 1), () {
            if (userType == UserTypeEnum.Tourist) {
              context.goNamed(AppRoutes.touristApp);
            } else {
              // Route guides to the dedicated guide dashboard
              context.goNamed(AppRoutes.guideApp);
            }
          });
        } else if (state is LoginFailureStates) {
          CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
            context: context,
            message: state.message,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoadingStates;
        return AbsorbPointer(
          absorbing: isLoading,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomHeightSpacingWidget(height: 40),
                    // Row(
                    //   children: [
                    //     CustomButtonWidget(
                    //       buttonWidth: 191,
                    //       buttonColor: userType == UserTypeEnum.Tourist
                    //           ? AppColors.primaryColor
                    //           : AppColors.whiteColor,
                    //       borderSideColor: userType == UserTypeEnum.Tourist
                    //           ? AppColors.primaryColor
                    //           : AppColors.whiteColor,
                    //       title: LocaleKeys.tourist.tr(),
                    //       titleStyle: userType == UserTypeEnum.Tourist
                    //           ? AppTextStyle.whiteW500S22
                    //           : AppTextStyle.primaryW500S22,
                    //       suffixSvgIcon: Assets.imagesSvgAirplane,
                    //       suffixIconColor: userType == UserTypeEnum.Tourist
                    //           ? AppColors.whiteColor
                    //           : AppColors.primaryColor,
                    //       suffixIconSize: 30,
                    //       buttonHeight: 50,
                    //     ),
                    //     CustomWidthSpacingWidget(width: 15),
                    //     CustomButtonWidget(
                    //       buttonWidth: 191,
                    //       buttonHeight: 50,
                    //       buttonColor: userType == UserTypeEnum.TourGuide
                    //           ? AppColors.primaryColor
                    //           : AppColors.whiteColor,
                    //       borderSideColor: userType == UserTypeEnum.TourGuide
                    //           ? AppColors.primaryColor
                    //           : AppColors.whiteColor,
                    //       title: LocaleKeys.guideLogin.tr(),
                    //       titleStyle: userType == UserTypeEnum.TourGuide
                    //           ? AppTextStyle.whiteW500S22
                    //           : AppTextStyle.primaryW500S22,
                    //       suffixSvgIcon: Assets.imagesSvgCompass,
                    //       suffixIconColor: userType == UserTypeEnum.TourGuide
                    //           ? AppColors.whiteColor
                    //           : AppColors.primaryColor,
                    //       suffixIconSize: 30,
                    //     ),
                    //   ],
                    // ),
                    CustomHeightSpacingWidget(height: 10),
                    Text(
                      LocaleKeys.loginWelcome.tr(),
                      style: AppTextStyle.primaryTextW500S17,
                    ),
                    CustomHeightSpacingWidget(height: 35),
                    Text(
                      LocaleKeys.email.tr(),
                      style: AppTextStyle.primaryTextW500S17,
                    ),
                    CustomHeightSpacingWidget(height: 5),
                    CustomTextFieldWidget(
                      hintText: LocaleKeys.enterEmail.tr(),
                      controller: emailController,
                      validator: (value) {
                        return Validators.validateEmail(value);
                      },
                    ),
                    CustomHeightSpacingWidget(height: 15),
                    Text(
                      LocaleKeys.password.tr(),
                      style: AppTextStyle.primaryTextW500S17,
                    ),
                    CustomHeightSpacingWidget(height: 5),
                    CustomTextFieldWidget(
                      hintText: LocaleKeys.enterPassword.tr(),
                      controller: passwordController,
                      validator: (value) {
                        return Validators.validatePassword(value);
                      },
                    ),
                    CustomHeightSpacingWidget(height: 10),
                    RememberAndForgotWiget(
                      email: emailController,
                      value: isRememberMeChecked,
                      onChanged: (value) {
                        setState(() {
                          isRememberMeChecked = value!;
                        });
                      },
                    ),
                    CustomHeightSpacingWidget(height: 30),
                    LoginButtonWidget(
                      state: state,
                      email: emailController,
                      password: passwordController,
                      formKey: formKey,
                    ),
                    CustomHeightSpacingWidget(height: 20),
                    BlocConsumer<LoginWithGoogleCubit, LoginWithGoogleStates>(
                      listener: (context, state) {
                        if (state is LoginWithGoogleFailureStates) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
                              context: context,
                              message: state.message,
                            );
                          });
                        } else if (state is LoginWithGoogleSuccessStates) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            CustomAnimatedShowSnackBar.successSnackBar(
                              context: context,
                              message: LocaleKeys.loginSuccessfully.tr(),
                            );
                          });
                        }
                      },
                      builder: (context, state) {
                        return GoogleSignInButton(
                          onPressed: () => context
                              .read<LoginWithGoogleCubit>()
                              .loginWithGoogle(),
                          isLoading: state is LoginWithGoogleLoadingStates,
                        );
                      },
                    ),
                    CustomHeightSpacingWidget(height: 10),
                    Center(
                      child: CustomRichTextWidget(
                        onTap: () {
                          context.pushNamed(AppRoutes.selectRoleScreen);
                        },
                        title: LocaleKeys.dontHaveAccount.tr(),
                        secondTitle: LocaleKeys.createAccount.tr(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
