import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/pick_image/pick_image_cubit.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/pick_image/pick_image_states.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/default_avatar_widget.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/image_source_bottom_sheet.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/selected_image_widget.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class RegisterImagePickerSection extends StatelessWidget {
  final ImageType imageType;

  const RegisterImagePickerSection({super.key, required this.imageType});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PickImageCubit, PickImageStates>(
      builder: (context, state) {
        final cubit = BlocProvider.of<PickImageCubit>(context);

        XFile? currentImage;
        String label = "";

        if (imageType == ImageType.profile) {
          currentImage = cubit.profileImage;
        } else if (imageType == ImageType.nationalId) {
          currentImage = cubit.nationalIdImage;
          label = LocaleKeys.selectNationalIdImage.tr();
        } else if (imageType == ImageType.license) {
          currentImage = cubit.licenseImage;
          label = LocaleKeys.selectGuideLicenseImage.tr();
        }

        // لو بروفايل، اعرض الشكل الدائري القديم
        if (imageType == ImageType.profile) {
          return Center(
            child: GestureDetector(
              onTap: () => _showBottomSheet(context),
              child: Stack(
                children: [
                  currentImage == null
                      ? const DefaultAvatarWidget()
                      : SelectedImageWidget(file: currentImage),
                  if (currentImage == null)
                    Positioned(
                      bottom: 11.h,
                      right: 7.w,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 30.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        // لو مستند (البطاقة أو الرخصة)، اعرض شكل الزرار/الحقل
        return GestureDetector(
          onTap: () => _showBottomSheet(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.secondaryTextColor.withOpacity(0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.image_search,
                  color: AppColors.primaryColor,
                  size: 24.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    currentImage == null ? label : currentImage.name,
                    style: currentImage == null
                        ? AppTextStyle.primaryTextW500S17.copyWith(
                            color: AppColors.secondaryTextColor,
                          )
                        : AppTextStyle.primaryTextW500S17.copyWith(
                            color: AppColors.primaryColor,
                          ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (currentImage != null)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    final cubit = context.read<PickImageCubit>();
    showModalBottomSheet(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: ImageSourceBottomSheet(imageType: imageType),
      ),
    );
  }
}
