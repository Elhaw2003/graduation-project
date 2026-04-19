import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/methods/custom_animated_snack_bar.dart';
import 'package:smart_guide/core/shared_widgets/custom_loading_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/settings/presentation/cubit/log_out/cubit/log_out_cubit.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class LogOutButtonWidget extends StatelessWidget {
  const LogOutButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogOutCubit, LogOutState>(
      listener: (context, state) {
        if (state is LogOutSuccessState) {
          CustomAnimatedShowSnackBar.successSnackBar(
            context: context,
            message: state.message,
          );
          Navigator.pop(context);
        } else if (state is LogOutFailureState) {
          CustomAnimatedShowSnackBar.failureSnackBar(
            context: context,
            message: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.redAppColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onPressed: () {
            context.read<LogOutCubit>().logOut();
          },
          child: state is LogOutLoadingState
              ? const CustomLoadingWidget(
                  color: AppColors.whiteColor,
                  cicleHeight: 25,
                  cicleWidth: 25,
                  strokeAlign: -1,
                  strokeWidth: 2,
                )
              : Text(
                  LocaleKeys.logout.tr(),
                  style: AppTextStyle.whitePoppinsW500S20,
                ),
        );
      },
    );
  }
}
