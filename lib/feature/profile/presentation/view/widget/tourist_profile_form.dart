import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';
import 'package:smart_guide/feature/profile/data/model/tourist_profile_model.dart';
import 'package:smart_guide/generated/assets.dart';

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

class _TouristProfileFormState extends State<TouristProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _countryCtrl;
  late final TextEditingController _whatsAppCtrl;
  String? _selectedImagePath;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.profile.firstName);
    _lastNameCtrl = TextEditingController(text: widget.profile.lastName);
    _countryCtrl = TextEditingController(text: widget.profile.country);
    _whatsAppCtrl = TextEditingController(text: widget.profile.whatsAppNumber);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _countryCtrl.dispose();
    _whatsAppCtrl.dispose();
    super.dispose();
  }

  bool _hasChanges() {
    if (_selectedImagePath != null) return true;
    final p = widget.profile;
    return _firstNameCtrl.text.trim() != p.firstName ||
        _lastNameCtrl.text.trim() != p.lastName ||
        _countryCtrl.text.trim() != p.country ||
        _whatsAppCtrl.text.trim() != p.whatsAppNumber;
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_hasChanges()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No changes detected'),
          backgroundColor: AppColors.starColore,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    widget.onSubmit(
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      country: _countryCtrl.text.trim(),
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
                'Choose Image Source',
                style: AppTextStyle.primaryPoppinsTextW600S18,
              ),
              CustomHeightSpacingWidget(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _imageSourceOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                  _imageSourceOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                ],
              ),
              CustomHeightSpacingWidget(height: 10),
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
              color: AppColors.primaryColor.withOpacity(0.1),
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
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() => _selectedImagePath = picked.path);
      widget.onImagePicked(picked.path);
    }
  }

  Widget _buildImagePreview() {
    if (_selectedImagePath != null) {
      return CircleAvatar(
        radius: 45.r,
        backgroundImage: FileImage(File(_selectedImagePath!)),
      );
    }

    if (widget.profile.touristImage.isNotEmpty) {
      return CircleAvatar(
        radius: 45.r,
        backgroundColor: AppColors.grey200Color,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: widget.profile.touristImage.toHttps(),
            width: 90.r,
            height: 90.r,
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
      radius: 45.r,
      backgroundColor: Colors.white.withOpacity(0.1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeightSpacingWidget(height: 20),

            // Image picker
            Center(
              child: GestureDetector(
                onTap: _showImagePickerSheet,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    _buildImagePreview(),
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.whiteColor,
                          width: 2.w,
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
            ),

            CustomHeightSpacingWidget(height: 24),

            Text('First Name', style: AppTextStyle.primaryPoppinsTextW500S15),
            CustomHeightSpacingWidget(height: 8),
            CustomTextFieldWidget(
              controller: _firstNameCtrl,
              hintText: 'Enter your first name',
              prefixIcon: Icons.person_outline,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'First name is required'
                  : null,
            ),

            CustomHeightSpacingWidget(height: 16),

            Text('Last Name', style: AppTextStyle.primaryPoppinsTextW500S15),
            CustomHeightSpacingWidget(height: 8),
            CustomTextFieldWidget(
              controller: _lastNameCtrl,
              hintText: 'Enter your last name',
              prefixIcon: Icons.person_outline,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Last name is required'
                  : null,
            ),

            CustomHeightSpacingWidget(height: 16),

            Text('Country', style: AppTextStyle.primaryPoppinsTextW500S15),
            CustomHeightSpacingWidget(height: 8),
            CustomTextFieldWidget(
              controller: _countryCtrl,
              hintText: 'Enter your country',
              prefixIcon: Icons.flag_outlined,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Country is required'
                  : null,
            ),

            CustomHeightSpacingWidget(height: 16),

            Text(
              'WhatsApp Number',
              style: AppTextStyle.primaryPoppinsTextW500S15,
            ),
            CustomHeightSpacingWidget(height: 8),
            CustomTextFieldWidget(
              controller: _whatsAppCtrl,
              hintText: 'Enter your WhatsApp number',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(11),
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'WhatsApp number is required'
                  : null,
            ),

            CustomHeightSpacingWidget(height: 30),

            Center(
              child: CustomButtonWidget(
                buttonWidth: double.infinity,
                buttonHeight: 52,
                buttonColor: AppColors.primaryColor,
                borderRadiusButton: 12,
                onPressed: widget.isLoading ? null : _handleSubmit,
                child: widget.isLoading
                    ? SizedBox(
                        height: 24.h,
                        width: 24.w,
                        child: CircularProgressIndicator(
                          color: AppColors.whiteColor,
                          strokeWidth: 3.0,
                        ),
                      )
                    : Text(
                        'Save Changes',
                        style: AppTextStyle.whitePoppinsW500S20.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
              ),
            ),

            CustomHeightSpacingWidget(height: 30),
          ],
        ),
      ),
    );
  }
}
