import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/pick_image/pick_image_cubit.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/pick_image/pick_image_states.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/default_avatar_widget.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/image_source_bottom_sheet.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/selected_image_widget.dart';

class RegisterImagePickerSection extends StatelessWidget {
  const RegisterImagePickerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PickImageCubit, PickImageStates>(
      builder: (context, state) {
        return Center(
          child: GestureDetector(
            onTap: () => _showBottomSheet(context),
            child: Stack(
              children: [
                BlocProvider.of<PickImageCubit>(context).image == null
                    ? const DefaultAvatarWidget()
                    : SelectedImageWidget(),
                if (BlocProvider.of<PickImageCubit>(context).image == null)
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
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    final cubit = context.read<PickImageCubit>();
    showModalBottomSheet(
      backgroundColor: AppColors.backgroundColor,
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.backgroundColor, width: 2.w),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: const ImageSourceBottomSheet(),
      ),
    );
  }
}
