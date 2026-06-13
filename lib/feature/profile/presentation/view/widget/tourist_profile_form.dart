import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_guide/core/methods/custom_animated_snack_bar.dart';
import 'package:smart_guide/core/methods/input_validator.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_loading_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/custom_drop_down_field.dart';
import 'package:smart_guide/feature/profile/data/model/tourist_profile_model.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/guide_profile_options.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class TouristProfileForm extends StatefulWidget {
  const TouristProfileForm({
    super.key,
    required this.profile,
    required this.onSubmit,
    required this.onImagePicked,
    required this.isLoading,
  });

  final TouristProfileModel profile;
  final void Function({
    required String firstName,
    required String lastName,
    required String country,
    required String whatsAppNumber,
    String? imagePath,
  })
  onSubmit;
  final void Function(String path) onImagePicked;
  final bool isLoading;

  @override
  State<TouristProfileForm> createState() => _TouristProfileFormState();
}

class _TouristProfileFormState extends State<TouristProfileForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _whatsAppCtrl;
  String? _selectedImagePath;
  String? _countrySelected;
  final _picker = ImagePicker();
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.profile.firstName);
    _lastNameCtrl = TextEditingController(text: widget.profile.lastName);
    _whatsAppCtrl = TextEditingController(text: widget.profile.whatsAppNumber);
    _countrySelected = widget.profile.country.isNotEmpty
        ? widget.profile.country
        : 'Egypt';

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _whatsAppCtrl.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  bool _hasChanges() {
    if (_selectedImagePath != null) return true;
    final p = widget.profile;
    return _firstNameCtrl.text.trim() != p.firstName ||
        _lastNameCtrl.text.trim() != p.lastName ||
        (_countrySelected ?? '') != p.country ||
        _whatsAppCtrl.text.trim() != p.whatsAppNumber;
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_countrySelected == null || _countrySelected!.isEmpty) {
      CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
        context: context,
        message: LocaleKeys.selectYourCountry.tr(),
      );
      return;
    }

    if (!_hasChanges()) {
      CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
        context: context,
        message: LocaleKeys.noChangesDetected.tr(),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      );
      return;
    }

    widget.onSubmit(
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      country: _countrySelected!,
      whatsAppNumber: _whatsAppCtrl.text.trim(),
      imagePath: _selectedImagePath,
    );
  }

  Future<void> _showImagePickerSheet() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                LocaleKeys.selectYourProfile.tr(),
                style: AppTextStyle.primaryPoppinsTextW600S18,
              ),
              CustomHeightSpacingWidget(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _imageSourceOption(
                    icon: Icons.camera_alt_rounded,
                    label: LocaleKeys.camera.tr(),
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                  _imageSourceOption(
                    icon: Icons.photo_library_rounded,
                    label: LocaleKeys.gallery.tr(),
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 30.sp),
          ),
          CustomHeightSpacingWidget(height: 8),
          Text(label, style: AppTextStyle.primaryPoppinsTextW500S15),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      setState(() => _selectedImagePath = picked.path);
      widget.onImagePicked(picked.path);
    }
  }

  Widget _buildImagePreview() {
    if (_selectedImagePath != null) {
      return CircleAvatar(
        radius: 52.r,
        backgroundImage: FileImage(File(_selectedImagePath!)),
      );
    }

    if (widget.profile.touristImage.isNotEmpty) {
      return CircleAvatar(
        radius: 52.r,
        backgroundColor: AppColors.grey200Color,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: widget.profile.touristImage.toHttps(),
            width: 104.r,
            height: 104.r,
            fit: BoxFit.cover,
            placeholder: (_, __) => _buildTransparentPlaceholder(),
            errorWidget: (_, __, ___) => _buildTransparentPlaceholder(),
          ),
        ),
      );
    }

    return _buildTransparentPlaceholder();
  }

  Widget _buildTransparentPlaceholder() {
    return CircleAvatar(
      radius: 52.r,
      backgroundColor: AppColors.primaryColor.withValues(alpha: 0.12),
      child: Icon(Icons.person, size: 48.sp, color: AppColors.primaryColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeightSpacingWidget(height: 20),
              _sectionCard(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _showImagePickerSheet,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: KeyedSubtree(
                              key: ValueKey(
                                _selectedImagePath ??
                                    widget.profile.touristImage,
                              ),
                              child: _buildImagePreview(),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(7.r),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.whiteColor,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: AppColors.whiteColor,
                              size: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomHeightSpacingWidget(height: 10),
                    Text(
                      LocaleKeys.editGuideProfileHint.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyle.grey300W400S16.copyWith(
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              CustomHeightSpacingWidget(height: 16),
              _sectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(LocaleKeys.personal_info.tr()),
                    CustomHeightSpacingWidget(height: 16),
                    Text(
                      LocaleKeys.firstName.tr(),
                      style: AppTextStyle.primaryPoppinsTextW500S15,
                    ),
                    CustomHeightSpacingWidget(height: 8),
                    CustomTextFieldWidget(
                      controller: _firstNameCtrl,
                      hintText: LocaleKeys.enterYourFirstName.tr(),
                      prefixIcon: Icons.person_outline,
                      validator: Validators.validateFirstName,
                    ),
                    CustomHeightSpacingWidget(height: 16),
                    Text(
                      LocaleKeys.lastName.tr(),
                      style: AppTextStyle.primaryPoppinsTextW500S15,
                    ),
                    CustomHeightSpacingWidget(height: 8),
                    CustomTextFieldWidget(
                      controller: _lastNameCtrl,
                      hintText: LocaleKeys.enterYourLastName.tr(),
                      prefixIcon: Icons.person_outline,
                      validator: Validators.validateLastName,
                    ),
                    CustomHeightSpacingWidget(height: 16),
                    Text(
                      LocaleKeys.yourCountry.tr(),
                      style: AppTextStyle.primaryPoppinsTextW500S15,
                    ),
                    CustomHeightSpacingWidget(height: 8),
                    CustomDropdownField(
                      value: _countrySelected,
                      hint: LocaleKeys.selectYourCountry.tr(),
                      items: GuideProfileOptions.countries,
                      onChanged: (value) {
                        setState(() => _countrySelected = value);
                      },
                    ),
                    CustomHeightSpacingWidget(height: 16),
                    Text(
                      LocaleKeys.whatsAppNum.tr(),
                      style: AppTextStyle.primaryPoppinsTextW500S15,
                    ),
                    CustomHeightSpacingWidget(height: 8),
                    CustomTextFieldWidget(
                      controller: _whatsAppCtrl,
                      hintText: LocaleKeys.enterWhatsAppNum.tr(),
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(15),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return LocaleKeys.validationEmpty.tr();
                        }
                        return Validators.validatePhoneNumber(value);
                      },
                    ),
                  ],
                ),
              ),
              CustomHeightSpacingWidget(height: 24),
              CustomButtonWidget(
                buttonWidth: double.infinity,
                buttonHeight: 54,
                buttonColor: AppColors.primaryColor,
                borderRadiusButton: 14,
                onPressed: widget.isLoading ? null : _handleSubmit,
                child: widget.isLoading
                    ? const CustomLoadingWidget(
                        color: AppColors.whiteColor,
                        strokeAlign: -1,
                        strokeWidth: 2,
                        cicleHeight: 25,
                        cicleWidth: 25,
                      )
                    : Text(
                        LocaleKeys.saveChanges.tr(),
                        style: AppTextStyle.whitePoppinsW500S20.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
              ),
              CustomHeightSpacingWidget(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(title, style: AppTextStyle.primaryPoppinsTextW600S18),
      ],
    );
  }
}
