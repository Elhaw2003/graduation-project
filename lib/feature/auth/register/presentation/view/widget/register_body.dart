import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/methods/custom_animated_snack_bar.dart';
import 'package:smart_guide/core/methods/input_validator.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_loading_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/auth/register/data/model/register_request_model.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/pick_image/pick_image_cubit.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/pick_image/pick_image_states.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/register/register_cubit.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/register/register_states.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/custom_drop_down_field.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/regisetr_image_picker_section.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/register_header_section.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key, required this.userTypeEnum});
  final UserTypeEnum userTypeEnum;

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isVisiblePassword = false;
  bool isVisibleConfirmPassword = false;
  String? countrySelected;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    userNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if (state is RegisterSuccessStates) {
          CustomAnimatedShowSnackBar.successSnackBar(
            context: context,
            message: LocaleKeys.registerSuccessfully.tr(),
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (context.mounted) {
              context.goNamed(AppRoutes.loginScreen);
            }
          });
        } else if (state is RegisterFailureStates) {
          CustomAnimatedShowSnackBar.failureSnackBar(
            context: context,
            message: state.message,
          );
        }
      },
      builder: (context, state) {
        return BlocBuilder<PickImageCubit, PickImageStates>(
          builder: (context, pickImageState) {
            final profilePath = context
                .read<PickImageCubit>()
                .profileImage
                ?.path;
            final licensePath = context
                .read<PickImageCubit>()
                .licenseImage
                ?.path;
            final nationalIdPath = context
                .read<PickImageCubit>()
                .nationalIdImage
                ?.path;

            return AbsorbPointer(
              absorbing: state is RegisterLoadingStates,
              child: CustomScrollView(
                slivers: [
                  // --- الجزء اللي بيثبت فوق (SliverAppBar) ---
                  SliverAppBar(
                    pinned: true, // يخليه يثبت فوق
                    floating: false,
                    // المساحة وهو مفرود (عدلها حسب حجم الهيدر عندك)
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                    surfaceTintColor: Colors.transparent,
                    leading: const CustomArrowBackButton(),
                  ),

                  // --- بقية الـ Form (SliverList أو SliverToBoxAdapter) ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 20.h,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ملحوظة: ممكن تنقل الـ RegisterHeaderSection هنا لو عايزها تتحرك وتختفي
                            RegisterHeaderSection(
                              userTypeEnum: widget.userTypeEnum,
                            ),
                            CustomHeightSpacingWidget(height: 40),
                            const RegisterImagePickerSection(
                              imageType: ImageType.profile,
                            ),
                            const CustomHeightSpacingWidget(height: 40),

                            // First Name
                            Text(
                              LocaleKeys.firstName.tr(),
                              style: AppTextStyle.primaryTextW500S17,
                            ),
                            const CustomHeightSpacingWidget(height: 5),
                            CustomTextFieldWidget(
                              controller: firstNameController,
                              hintText: LocaleKeys.enterYourFirstName.tr(),
                              validator: (value) =>
                                  Validators.validateFirstName(value),
                            ),
                            const CustomHeightSpacingWidget(height: 15),

                            // Last Name
                            Text(
                              LocaleKeys.lastName.tr(),
                              style: AppTextStyle.primaryTextW500S17,
                            ),
                            const CustomHeightSpacingWidget(height: 5),
                            CustomTextFieldWidget(
                              controller: lastNameController,
                              hintText: LocaleKeys.enterYourLastName.tr(),
                              validator: (value) =>
                                  Validators.validateLastName(value),
                            ),
                            const CustomHeightSpacingWidget(height: 15),

                            // User Name
                            Text(
                              LocaleKeys.userName.tr(),
                              style: AppTextStyle.primaryTextW500S17,
                            ),
                            const CustomHeightSpacingWidget(height: 5),
                            CustomTextFieldWidget(
                              controller: userNameController,
                              hintText: LocaleKeys.enterUserName.tr(),
                              validator: (value) =>
                                  Validators.validateUserName(value),
                            ),
                            const CustomHeightSpacingWidget(height: 15),

                            // Email
                            Text(
                              LocaleKeys.email.tr(),
                              style: AppTextStyle.primaryTextW500S17,
                            ),
                            const CustomHeightSpacingWidget(height: 5),
                            CustomTextFieldWidget(
                              controller: emailController,
                              hintText: LocaleKeys.enterEmail.tr(),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                                  Validators.validateEmail(value),
                            ),
                            const CustomHeightSpacingWidget(height: 15),

                            // Phone
                            Text(
                              LocaleKeys.phone.tr(),
                              style: AppTextStyle.primaryTextW500S17,
                            ),
                            const CustomHeightSpacingWidget(height: 5),
                            CustomTextFieldWidget(
                              controller: phoneController,
                              hintText: LocaleKeys.enterPhone.tr(),
                              keyboardType: TextInputType.phone,
                              validator: (value) =>
                                  Validators.validatePhoneNumber(value),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            const CustomHeightSpacingWidget(height: 15),

                            // Password
                            Text(
                              LocaleKeys.password.tr(),
                              style: AppTextStyle.primaryTextW500S17,
                            ),
                            const CustomHeightSpacingWidget(height: 5),
                            CustomTextFieldWidget(
                              controller: passwordController,
                              hintText: LocaleKeys.enterPassword.tr(),
                              helperText: LocaleKeys.passwordDescription.tr(),
                              helperMaxLines: 2,
                              obscureText: !isVisiblePassword,
                              suffixIcon: isVisiblePassword
                                  ? Icons.visibility
                                  : Icons.visibility_outlined,
                              suffixOnPressed: () => setState(
                                () => isVisiblePassword = !isVisiblePassword,
                              ),
                              validator: (value) =>
                                  Validators.validatePassword(value),
                            ),
                            const CustomHeightSpacingWidget(height: 15),

                            // Confirm Password
                            Text(
                              LocaleKeys.confirmPassword.tr(),
                              style: AppTextStyle.primaryTextW500S17,
                            ),
                            const CustomHeightSpacingWidget(height: 5),
                            CustomTextFieldWidget(
                              controller: confirmPasswordController,
                              hintText: LocaleKeys.confirmPassword.tr(),
                              obscureText: !isVisibleConfirmPassword,
                              suffixIcon: isVisibleConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_outlined,
                              suffixOnPressed: () => setState(
                                () => isVisibleConfirmPassword =
                                    !isVisibleConfirmPassword,
                              ),
                              validator: (value) =>
                                  Validators.validateRetypePassword(
                                    value: value,
                                    originalPassword: passwordController.text,
                                  ),
                            ),
                            const CustomHeightSpacingWidget(height: 15),

                            // Country
                            Text(
                              LocaleKeys.yourCountry.tr(),
                              style: AppTextStyle.primaryTextW500S17,
                            ),
                            const CustomHeightSpacingWidget(height: 5),
                            CustomDropdownField(
                              value: countrySelected,
                              hint: LocaleKeys.selectYourCountry.tr(),
                              items: ["Egypt", "USA", "France", "Congo"],
                              onChanged: (value) {
                                setState(() => countrySelected = value);
                              },
                            ),

                            // Additional Documents for Guide Role
                            if (widget.userTypeEnum ==
                                UserTypeEnum.TourGuide) ...[
                              const CustomHeightSpacingWidget(height: 25),
                              Text(
                                LocaleKeys.nationalId.tr(),
                                style: AppTextStyle.primaryTextW500S17,
                              ),
                              const CustomHeightSpacingWidget(height: 10),
                              const RegisterImagePickerSection(
                                imageType: ImageType.nationalId,
                              ),
                              const CustomHeightSpacingWidget(height: 25),
                              Text(
                                LocaleKeys.uploadIdOrLicense.tr(),
                                style: AppTextStyle.primaryTextW500S17,
                              ),
                              const CustomHeightSpacingWidget(height: 10),
                              const RegisterImagePickerSection(
                                imageType: ImageType.license,
                              ),
                            ],

                            const CustomHeightSpacingWidget(height: 40),

                            CustomButtonWidget(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if (profilePath == null) {
                                    CustomAnimatedShowSnackBar.failureSnackBar(
                                      context: context,
                                      message: LocaleKeys.profileImageRequired
                                          .tr(),
                                      mobileSnackBarPosition:
                                          MobileSnackBarPosition.top,
                                    );
                                    return;
                                  }

                                  if (widget.userTypeEnum ==
                                      UserTypeEnum.TourGuide) {
                                    if (nationalIdPath == null ||
                                        licensePath == null) {
                                      CustomAnimatedShowSnackBar.failureSnackBar(
                                        context: context,
                                        message: LocaleKeys.idAndLicenseRequired
                                            .tr(),
                                        mobileSnackBarPosition:
                                            MobileSnackBarPosition.top,
                                      );
                                      return;
                                    }
                                  }

                                  context.read<RegisterCubit>().register(
                                    registerRequestModel: RegisterRequestModel(
                                      email: emailController.text.trim(),
                                      firstName: firstNameController.text
                                          .trim(),
                                      lastName: lastNameController.text.trim(),
                                      userName: userNameController.text.trim(),
                                      password: passwordController.text.trim(),
                                      confirmPassword: confirmPasswordController
                                          .text
                                          .trim(),
                                      country: countrySelected ?? "Egypt",
                                      role:
                                          widget.userTypeEnum ==
                                              UserTypeEnum.TourGuide
                                          ? "TourGuide"
                                          : "Tourist",
                                      profileImage: profilePath,
                                      guideLicenseImage: licensePath,
                                      nationalIdImage: nationalIdPath,
                                      whatsAppNumber: phoneController.text
                                          .trim(),
                                    ),
                                  );
                                }
                              },
                              buttonColor: state is RegisterLoadingStates
                                  ? AppColors.primaryColor.withValues(
                                      alpha: 0.5,
                                    )
                                  : AppColors.primaryColor,
                              buttonWidth: double.infinity,
                              title: LocaleKeys.createAccount.tr(),
                              child: state is RegisterLoadingStates
                                  ? const CustomLoadingWidget(
                                      color: AppColors.whiteColor,
                                      strokeAlign: -1,
                                      strokeWidth: 2,
                                      cicleHeight: 25,
                                      cicleWidth: 25,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
