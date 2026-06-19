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
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_loading_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/auth/register/data/model/register_request_model.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/pick_image/pick_image_cubit.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/register/register_cubit.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/register/register_states.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/custom_drop_down_field.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/regisetr_image_picker_section.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key, required this.userTypeEnum});
  final UserTypeEnum userTypeEnum;

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // One form key per step
  final GlobalKey<FormState> _step1Key = GlobalKey<FormState>();
  final GlobalKey<FormState> _step2Key = GlobalKey<FormState>();

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

  bool get _isGuide => widget.userTypeEnum == UserTypeEnum.TourGuide;
  int get _totalSteps => 3;

  @override
  void dispose() {
    _pageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    userNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _nextStep() {
    final valid = _currentStep == 0
        ? (_step1Key.currentState?.validate() ?? false)
        : (_step2Key.currentState?.validate() ?? false);

    if (!valid) return;
    if (countrySelected == null && _currentStep == 1) {
      CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
        context: context,
        message: LocaleKeys.selectYourCountry.tr(),
      );
      return;
    }

    setState(() => _currentStep++);
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _prevStep() {
    if (_currentStep == 0) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _currentStep--);
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _submit() {
    final pickCubit = context.read<PickImageCubit>();
    final profilePath = pickCubit.profileImage?.path;
    final licensePath = pickCubit.licenseImage?.path;
    final nationalIdPath = pickCubit.nationalIdImage?.path;

    if (profilePath == null) {
      CustomAnimatedShowSnackBar.failureSnackBar(
        context: context,
        message: LocaleKeys.profileImageRequired.tr(),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      );
      return;
    }

    if (_isGuide && (nationalIdPath == null || licensePath == null)) {
      CustomAnimatedShowSnackBar.failureSnackBar(
        context: context,
        message: LocaleKeys.idAndLicenseRequired.tr(),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      );
      return;
    }

    context.read<RegisterCubit>().register(
      registerRequestModel: RegisterRequestModel(
        email: emailController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        userName: userNameController.text.trim(),
        password: passwordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        country: countrySelected ?? "Egypt",
        role: _isGuide ? "TourGuide" : "Tourist",
        profileImage: profilePath,
        guideLicenseImage: licensePath,
        nationalIdImage: nationalIdPath,
        whatsAppNumber: phoneController.text.trim(),
      ),
    );
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
            if (context.mounted) context.goNamed(AppRoutes.loginScreen);
          });
        } else if (state is RegisterFailureStates) {
          CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
            context: context,
            message: state.message,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RegisterLoadingStates;
        return AbsorbPointer(
          absorbing: isLoading,
          child: Column(
            children: [
              // ─── AppBar area ───────────────────────────────────────────
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _prevStep,
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20.sp,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      Expanded(
                        child: _StepIndicator(
                          totalSteps: _totalSteps,
                          currentStep: _currentStep,
                        ),
                      ),
                      SizedBox(width: 48.w), // balance the back button
                    ],
                  ),
                ),
              ),

              // ─── Page content ──────────────────────────────────────────
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _Step1PersonalInfo(
                      formKey: _step1Key,
                      firstNameController: firstNameController,
                      lastNameController: lastNameController,
                      userNameController: userNameController,
                      isGuide: _isGuide,
                    ),
                    _Step2AccountDetails(
                      formKey: _step2Key,
                      emailController: emailController,
                      phoneController: phoneController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      countrySelected: countrySelected,
                      isVisiblePassword: isVisiblePassword,
                      isVisibleConfirmPassword: isVisibleConfirmPassword,
                      onCountryChanged: (v) =>
                          setState(() => countrySelected = v),
                      onTogglePassword: () => setState(
                        () => isVisiblePassword = !isVisiblePassword,
                      ),
                      onToggleConfirm: () => setState(
                        () => isVisibleConfirmPassword =
                            !isVisibleConfirmPassword,
                      ),
                      isGuide: _isGuide,
                    ),
                    _Step3Photos(isGuide: _isGuide),
                  ],
                ),
              ),

              // ─── Bottom button ─────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                child: CustomButtonWidget(
                  onPressed: _currentStep < _totalSteps - 1
                      ? _nextStep
                      : _submit,
                  buttonColor: isLoading
                      ? AppColors.primaryColor.withValues(alpha: 0.5)
                      : AppColors.primaryColor,
                  buttonWidth: double.infinity,
                  title: _currentStep < _totalSteps - 1
                      ? LocaleKeys.next.tr()
                      : LocaleKeys.createAccount.tr(),
                  child: isLoading
                      ? const CustomLoadingWidget(
                          color: AppColors.whiteColor,
                          strokeAlign: -1,
                          strokeWidth: 2,
                          cicleHeight: 25,
                          cicleWidth: 25,
                        )
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Step Indicator
// ═══════════════════════════════════════════════════════════════

class _StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const _StepIndicator({required this.totalSteps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps * 2 - 1, (i) {
        if (i.isOdd) {
          // connector line
          final stepIndex = i ~/ 2;
          final isDone = stepIndex < currentStep;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2.h,
              color: isDone ? AppColors.primaryColor : AppColors.grey200Color,
            ),
          );
        }
        final stepIndex = i ~/ 2;
        final isDone = stepIndex < currentStep;
        final isCurrent = stepIndex == currentStep;
        return _StepCircle(
          index: stepIndex,
          isDone: isDone,
          isCurrent: isCurrent,
        );
      }),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int index;
  final bool isDone;
  final bool isCurrent;

  const _StepCircle({
    required this.index,
    required this.isDone,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone
            ? AppColors.primaryColor
            : isCurrent
            ? Colors.white
            : AppColors.grey200Color,
        border: Border.all(
          color: isDone || isCurrent
              ? AppColors.primaryColor
              : AppColors.grey200Color,
          width: 2,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.25),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Center(
        child: isDone
            ? Icon(Icons.check_rounded, color: Colors.white, size: 16.sp)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: isCurrent
                      ? AppColors.primaryColor
                      : AppColors.grey400Color,
                ),
              ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Step 1 – Personal Info
// ═══════════════════════════════════════════════════════════════

class _Step1PersonalInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController userNameController;
  final bool isGuide;

  const _Step1PersonalInfo({
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.userNameController,
    required this.isGuide,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            _StepHeader(
              icon: Icons.person_outline_rounded,
              title: 'Personal Info',
              subtitle: isGuide
                  ? 'Tell us who you are as a guide'
                  : 'Tell us a bit about yourself',
            ),
            SizedBox(height: 28.h),

            _FieldLabel(LocaleKeys.firstName.tr()),
            SizedBox(height: 6.h),
            CustomTextFieldWidget(
              controller: firstNameController,
              hintText: LocaleKeys.enterYourFirstName.tr(),
              validator: (value) => Validators.validateFirstName(value),
            ),
            SizedBox(height: 16.h),

            _FieldLabel(LocaleKeys.lastName.tr()),
            SizedBox(height: 6.h),
            CustomTextFieldWidget(
              controller: lastNameController,
              hintText: LocaleKeys.enterYourLastName.tr(),
              validator: (value) => Validators.validateLastName(value),
            ),
            SizedBox(height: 16.h),

            _FieldLabel(LocaleKeys.userName.tr()),
            SizedBox(height: 6.h),
            CustomTextFieldWidget(
              controller: userNameController,
              hintText: LocaleKeys.enterUserName.tr(),
              validator: (value) => Validators.validateUserName(value),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Step 2 – Account Details
// ═══════════════════════════════════════════════════════════════

class _Step2AccountDetails extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String? countrySelected;
  final bool isVisiblePassword;
  final bool isVisibleConfirmPassword;
  final ValueChanged<String?> onCountryChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;
  final bool isGuide;
  const _Step2AccountDetails({
    required this.formKey,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.countrySelected,
    required this.isVisiblePassword,
    required this.isVisibleConfirmPassword,
    required this.onCountryChanged,
    required this.onTogglePassword,
    required this.onToggleConfirm,
    required this.isGuide,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            _StepHeader(
              icon: Icons.lock_outline_rounded,
              title: 'Account Details',
              subtitle: 'Set up your login credentials',
            ),
            SizedBox(height: 28.h),

            _FieldLabel(LocaleKeys.email.tr()),
            SizedBox(height: 6.h),
            CustomTextFieldWidget(
              controller: emailController,
              hintText: LocaleKeys.enterEmail.tr(),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validators.validateEmail(value),
            ),
            SizedBox(height: 16.h),

            _FieldLabel(LocaleKeys.phone.tr()),
            SizedBox(height: 6.h),
            CustomTextFieldWidget(
              controller: phoneController,
              hintText: LocaleKeys.enterPhone.tr(),
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  Validators.validatePhoneNumber(value, isGuide: isGuide),
              inputFormatters: isGuide
                  ? [
                      LengthLimitingTextInputFormatter(11),
                      FilteringTextInputFormatter.digitsOnly,
                    ]
                  : [],
            ),
            SizedBox(height: 16.h),

            _FieldLabel(LocaleKeys.yourCountry.tr()),
            SizedBox(height: 6.h),
            CustomDropdownField(
              value: countrySelected,
              hint: LocaleKeys.selectYourCountry.tr(),
              items: const ["Egypt", "USA", "France", "Congo"],
              onChanged: onCountryChanged,
            ),
            SizedBox(height: 16.h),

            _FieldLabel(LocaleKeys.password.tr()),
            SizedBox(height: 6.h),
            CustomTextFieldWidget(
              controller: passwordController,
              hintText: LocaleKeys.enterPassword.tr(),
              helperText: LocaleKeys.passwordDescription.tr(),
              helperMaxLines: 2,
              obscureText: !isVisiblePassword,
              suffixIcon: isVisiblePassword
                  ? Icons.visibility
                  : Icons.visibility_outlined,
              suffixOnPressed: onTogglePassword,
              validator: (value) => Validators.validatePassword(value),
            ),
            SizedBox(height: 16.h),

            _FieldLabel(LocaleKeys.confirmPassword.tr()),
            SizedBox(height: 6.h),
            CustomTextFieldWidget(
              controller: confirmPasswordController,
              hintText: LocaleKeys.confirmPassword.tr(),
              obscureText: !isVisibleConfirmPassword,
              suffixIcon: isVisibleConfirmPassword
                  ? Icons.visibility
                  : Icons.visibility_outlined,
              suffixOnPressed: onToggleConfirm,
              validator: (value) => Validators.validateRetypePassword(
                value: value,
                originalPassword: passwordController.text,
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Step 3 – Photos & Documents
// ═══════════════════════════════════════════════════════════════

class _Step3Photos extends StatelessWidget {
  final bool isGuide;

  const _Step3Photos({required this.isGuide});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          _StepHeader(
            icon: Icons.photo_camera_outlined,
            title: isGuide ? 'Photos & Documents' : 'Profile Photo',
            subtitle: isGuide
                ? 'Upload your photo and verification documents'
                : 'Add a profile photo so others can recognize you',
          ),
          SizedBox(height: 28.h),

          // Profile image
          Center(
            child: Column(
              children: [
                Text(
                  LocaleKeys.profileImage.tr(),
                  style: AppTextStyle.primaryTextW500S17,
                ),
                SizedBox(height: 12.h),
                const RegisterImagePickerSection(imageType: ImageType.profile),
              ],
            ),
          ),

          if (isGuide) ...[
            SizedBox(height: 28.h),
            _FieldLabel(LocaleKeys.nationalId.tr()),
            SizedBox(height: 10.h),
            const RegisterImagePickerSection(imageType: ImageType.nationalId),
            SizedBox(height: 20.h),
            _FieldLabel(LocaleKeys.uploadIdOrLicense.tr()),
            SizedBox(height: 10.h),
            const RegisterImagePickerSection(imageType: ImageType.license),
          ],

          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Shared small widgets
// ═══════════════════════════════════════════════════════════════

class _StepHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StepHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 26.sp),
        ),
        SizedBox(height: 14.h),
        Text(
          title,
          style: AppTextStyle.primaryTextW500S21.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: AppTextStyle.primaryTextW400S14.copyWith(
            color: AppColors.secondaryTextColor,
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyle.primaryTextW500S17);
  }
}
