import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/pick_image/pick_image_cubit.dart';

class SelectedImageWidget extends StatelessWidget {
  const SelectedImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      height: 150.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryColor, width: 2.w),
      ),
      child: ClipOval(
        child: Image.file(
          File(BlocProvider.of<PickImageCubit>(context).image!.path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
