import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart'; // أضفنا هذا الـ import
import 'package:smart_guide/core/utils/app_colors.dart';

class SelectedImageWidget extends StatelessWidget {
  // أضفنا ملف من نوع XFile عشان نقدر نعرض أي صورة نختارها
  final XFile? file;

  const SelectedImageWidget({super.key, this.file});

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
        child: file != null
            ? Image.file(File(file!.path), fit: BoxFit.cover)
            : const SizedBox(), // حالة احتياطية لو الملف فاضي
      ),
    );
  }
}
