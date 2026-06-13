import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_guide/core/methods/custom_animated_snack_bar.dart';
import 'package:smart_guide/core/methods/input_validator.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_loading_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';
import 'package:smart_guide/feature/all_guides/data/model/tour_guide_model.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/custom_drop_down_field.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/guide_profile_options.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/model/guide_gallery_edit_item.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/edit_guide_profile/edit_guide_profile_cubit.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/edit_guide_profile/edit_guide_profile_states.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/view/widget/gallery_picker_grid.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/view/widget/multi_select_chip_picker.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class EditGuideProfileScreen extends StatefulWidget {
  const EditGuideProfileScreen({
    super.key,
    required this.guideId,
    this.initialProfile,
  });

  final String guideId;
  final TourGuideModel? initialProfile;

  @override
  State<EditGuideProfileScreen> createState() => _EditGuideProfileScreenState();
}

class _EditGuideProfileScreenState extends State<EditGuideProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _whatsAppCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _priceCtrl;

  String? _countrySelected;
  List<String> _selectedCities = [];
  List<String> _selectedLanguages = [];
  List<GuideGalleryEditItem> _galleryItems = [];
  late List<GuideGalleryEditItem> _initialGalleryItems;
  String? _newProfilePicturePath;

  bool _isAuthorized = false;
  bool _isCheckingAccess = true;

  @override
  void initState() {
    super.initState();
    final profile = widget.initialProfile;
    _firstNameCtrl = TextEditingController(text: profile?.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: profile?.lastName ?? '');
    _whatsAppCtrl = TextEditingController(text: profile?.whatsAppNumber ?? '');
    _bioCtrl = TextEditingController(text: profile?.bio ?? '');
    _priceCtrl = TextEditingController(
      text: profile != null && profile.pricePerDay > 0
          ? profile.pricePerDay.toStringAsFixed(0)
          : '',
    );
    _countrySelected = profile?.country.isNotEmpty == true
        ? profile!.country
        : 'Egypt';
    _selectedCities = List<String>.from(profile?.cities ?? []);
    _selectedLanguages = List<String>.from(profile?.languages ?? []);
    _galleryItems = (profile?.gallery ?? [])
        .map((url) => GuideGalleryEditItem.network(url))
        .toList();
    _initialGalleryItems = List<GuideGalleryEditItem>.from(_galleryItems);
    _verifyAccess();
  }

  bool _hasGalleryChanges() {
    if (_galleryItems.length != _initialGalleryItems.length) return true;
    for (var i = 0; i < _galleryItems.length; i++) {
      final current = _galleryItems[i];
      final initial = _initialGalleryItems[i];
      if (current.isLocal != initial.isLocal) return true;
      if (current.isLocal && current.localPath != initial.localPath) {
        return true;
      }
      if (current.isNetwork && current.networkUrl != initial.networkUrl) {
        return true;
      }
    }
    return false;
  }

  List<String> _retainedGalleryUrls() {
    return _galleryItems
        .where((item) => item.isNetwork)
        .map((item) => item.networkUrl!)
        .toList();
  }

  List<String> _newGalleryPaths() {
    return _galleryItems
        .where((item) => item.isLocal)
        .map((item) => item.localPath!)
        .toList();
  }

  Future<void> _verifyAccess() async {
    final storage = SecureStorageHelper.instance;
    final userType = await storage.getUserTypeEnum();
    final currentUserId = await storage.getUserId();

    if (!mounted) return;

    final isGuide = userType == UserTypeEnum.TourGuide;
    final isOwnProfile = currentUserId == widget.guideId;

    if (!isGuide || !isOwnProfile) {
      setState(() {
        _isAuthorized = false;
        _isCheckingAccess = false;
      });
      CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
        context: context,
        message: LocaleKeys.unauthorizedAccess.tr(),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      );
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) context.pop();
      });
      return;
    }

    setState(() {
      _isAuthorized = true;
      _isCheckingAccess = false;
    });
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _whatsAppCtrl.dispose();
    _bioCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickProfilePicture(ImageSource source) async {
    Navigator.pop(context);
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      setState(() => _newProfilePicturePath = picked.path);
    }
  }

  void _showProfileImageSheet() {
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
                  _imageSourceTile(
                    icon: Icons.camera_alt_rounded,
                    label: LocaleKeys.camera.tr(),
                    onTap: () => _pickProfilePicture(ImageSource.camera),
                  ),
                  _imageSourceTile(
                    icon: Icons.photo_library_rounded,
                    label: LocaleKeys.gallery.tr(),
                    onTap: () => _pickProfilePicture(ImageSource.gallery),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageSourceTile({
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

  Widget _buildProfileAvatar(String? networkUrl) {
    if (_newProfilePicturePath != null) {
      return CircleAvatar(
        radius: 52.r,
        backgroundImage: FileImage(File(_newProfilePicturePath!)),
      );
    }

    if (networkUrl != null && networkUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 52.r,
        backgroundColor: AppColors.grey200Color,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: networkUrl.toHttps(),
            width: 104.r,
            height: 104.r,
            fit: BoxFit.cover,
            placeholder: (_, __) => _avatarPlaceholder(),
            errorWidget: (_, __, ___) => _avatarPlaceholder(),
          ),
        ),
      );
    }

    return _avatarPlaceholder();
  }

  Widget _avatarPlaceholder() {
    return CircleAvatar(
      radius: 52.r,
      backgroundColor: AppColors.primaryColor.withValues(alpha: 0.15),
      child: Icon(Icons.person, size: 48.sp, color: AppColors.primaryColor),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedCities.isEmpty) {
      CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
        context: context,
        message: LocaleKeys.selectAtLeastOneCity.tr(),
      );
      return;
    }

    if (_selectedLanguages.isEmpty) {
      CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
        context: context,
        message: LocaleKeys.selectAtLeastOneLanguage.tr(),
      );
      return;
    }

    if (_countrySelected == null || _countrySelected!.isEmpty) {
      CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
        context: context,
        message: LocaleKeys.selectYourCountry.tr(),
      );
      return;
    }

    final price = double.tryParse(_priceCtrl.text.trim());
    if (price == null || price <= 0) {
      CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
        context: context,
        message: LocaleKeys.priceInvalid.tr(),
      );
      return;
    }

    final newGalleryPaths = _newGalleryPaths();
    final galleryChanged = _hasGalleryChanges();

    context.read<EditGuideProfileCubit>().updateGuideProfile(
      id: widget.guideId,
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      country: _countrySelected!,
      whatsAppNumber: _whatsAppCtrl.text.trim(),
      bio: _bioCtrl.text.trim(),
      pricePerDay: price,
      cities: _selectedCities,
      languages: _selectedLanguages,
      profilePicturePath: _newProfilePicturePath,
      retainedGalleryUrls: galleryChanged ? _retainedGalleryUrls() : null,
      newGalleryPaths: galleryChanged && newGalleryPaths.isNotEmpty
          ? newGalleryPaths
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAccess) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    }

    if (!_isAuthorized) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final networkProfilePic = widget.initialProfile?.profilePicture;

    return BlocConsumer<EditGuideProfileCubit, EditGuideProfileState>(
      listener: (context, state) async {
        if (state is EditGuideProfileSuccess) {
          CustomAnimatedShowSnackBar.successSnackBar(
            context: context,
            message: state.message,
          );
          if (context.mounted) context.pop(state.profile);
        } else if (state is EditGuideProfileFailure) {
          CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
            context: context,
            message: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is EditGuideProfileLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FF),
          body: AbsorbPointer(
            absorbing: isLoading,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 220.h,
                  pinned: true,
                  stretch: true,
                  backgroundColor: AppColors.primaryColor,
                  leading: Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: const CustomArrowBackButton(iconColor: Colors.white),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          Assets.imagesPngPyramids,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primaryColor.withValues(alpha: 0.75),
                                AppColors.primaryColor.withValues(alpha: 0.92),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: _showProfileImageSheet,
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      _buildProfileAvatar(networkProfilePic),
                                      Container(
                                        padding: EdgeInsets.all(7.r),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 16.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  LocaleKeys.editProfile.tr(),
                                  style: AppTextStyle.backgroundW500S17
                                      .copyWith(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(height: 4.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                  ),
                                  child: Text(
                                    LocaleKeys.editGuideProfileHint.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 30.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                    return Validators.validatePhoneNumber(
                                      value,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          CustomHeightSpacingWidget(height: 16),
                          _sectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle(LocaleKeys.guide.tr()),
                                CustomHeightSpacingWidget(height: 16),
                                Text(
                                  LocaleKeys.bio.tr(),
                                  style: AppTextStyle.primaryPoppinsTextW500S15,
                                ),
                                CustomHeightSpacingWidget(height: 8),
                                CustomTextFieldWidget(
                                  controller: _bioCtrl,
                                  hintText: LocaleKeys.enterBio.tr(),
                                  prefixIcon: Icons.notes_outlined,
                                  maxLines: 4,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return LocaleKeys.bioRequired.tr();
                                    }
                                    return null;
                                  },
                                ),
                                CustomHeightSpacingWidget(height: 16),
                                Text(
                                  LocaleKeys.pricePerDay.tr(),
                                  style: AppTextStyle.primaryPoppinsTextW500S15,
                                ),
                                CustomHeightSpacingWidget(height: 8),
                                CustomTextFieldWidget(
                                  controller: _priceCtrl,
                                  hintText: LocaleKeys.enterPricePerDay.tr(),
                                  prefixIcon: Icons.payments_outlined,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,2}'),
                                    ),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return LocaleKeys.priceRequired.tr();
                                    }
                                    final parsed = double.tryParse(value);
                                    if (parsed == null || parsed <= 0) {
                                      return LocaleKeys.priceInvalid.tr();
                                    }
                                    return null;
                                  },
                                ),
                                CustomHeightSpacingWidget(height: 16),
                                MultiSelectChipPicker(
                                  label: LocaleKeys.selectCities.tr(),
                                  hint: LocaleKeys.selectCities.tr(),
                                  options: GuideProfileOptions.egyptianCities,
                                  selected: _selectedCities,
                                  icon: Icons.location_city_outlined,
                                  onChanged: (values) {
                                    setState(() => _selectedCities = values);
                                  },
                                ),
                                CustomHeightSpacingWidget(height: 16),
                                MultiSelectChipPicker(
                                  label: LocaleKeys.selectLanguages.tr(),
                                  hint: LocaleKeys.selectLanguagesYouSpeak.tr(),
                                  options: GuideProfileOptions.languages,
                                  selected: _selectedLanguages,
                                  icon: Icons.translate_outlined,
                                  onChanged: (values) {
                                    setState(() => _selectedLanguages = values);
                                  },
                                ),
                              ],
                            ),
                          ),
                          CustomHeightSpacingWidget(height: 16),
                          _sectionCard(
                            child: GalleryPickerGrid(
                              items: _galleryItems,
                              onChanged: (items) {
                                setState(() => _galleryItems = items);
                              },
                            ),
                          ),
                          CustomHeightSpacingWidget(height: 24),
                          CustomButtonWidget(
                            onPressed: isLoading ? null : _submit,
                            buttonWidth: double.infinity,
                            buttonHeight: 54,
                            buttonColor: AppColors.primaryColor,
                            borderRadiusButton: 14,
                            child: isLoading
                                ? const CustomLoadingWidget(
                                    color: AppColors.whiteColor,
                                    strokeAlign: -1,
                                    strokeWidth: 2,
                                    cicleHeight: 25,
                                    cicleWidth: 25,
                                  )
                                : Text(
                                    LocaleKeys.saveChanges.tr(),
                                    style: AppTextStyle.whitePoppinsW500S20
                                        .copyWith(fontSize: 16.sp),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
