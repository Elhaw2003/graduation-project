import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/pick_image/pick_image_cubit.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  // أضفنا النوع هنا عشان الـ BottomSheet تعرف هي بتحدث أي صورة
  final ImageType imageType;

  const ImageSourceBottomSheet({super.key, required this.imageType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: const Icon(
              Icons.camera_alt_outlined,
              size: 30,
              color: AppColors.primaryColor,
            ),
            title: Text(
              LocaleKeys.camera.tr(),
              style: AppTextStyle.primaryTextW500S17,
            ),
            onTap: () {
              context.read<PickImageCubit>().pickImage(
                ImageSource.camera,
                context,
                imageType, // تمرير النوع للـ Cubit
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.image,
              size: 30,
              color: AppColors.primaryColor,
            ),
            title: Text(
              LocaleKeys.gallery.tr(),
              style: AppTextStyle.primaryTextW500S17,
            ),
            onTap: () {
              context.read<PickImageCubit>().pickImage(
                ImageSource.gallery,
                context,
                imageType, // تمرير النوع للـ Cubit
              );
            },
          ),
        ],
      ),
    );
  }
}
