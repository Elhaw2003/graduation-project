import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/chat/presentation/cubit/chat_inbox/chat_inbox_cubit.dart';
import 'package:smart_guide/feature/chat/presentation/cubit/chat_inbox/chat_inbox_states.dart';

class CustomContainerAboutTheGuide extends StatefulWidget {
  const CustomContainerAboutTheGuide({
    super.key,
    required this.name,
    required this.aboutGuide,
    required this.guideId,
  });
  final String name;
  final String aboutGuide;
  final String guideId;

  @override
  State<CustomContainerAboutTheGuide> createState() =>
      _CustomContainerAboutTheGuideState();
}

class _CustomContainerAboutTheGuideState
    extends State<CustomContainerAboutTheGuide> {
  bool _isExpanded = false;
  bool _isTourist = false;

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    final type = await SecureStorageHelper.instance.getUserTypeEnum();
    if (mounted) setState(() => _isTourist = type == UserTypeEnum.Tourist);
  }

  @override
  Widget build(BuildContext context) {
    // Inject fallback description pattern if the profile bio is empty or missing
    final String parsedBio = widget.aboutGuide.isNotEmpty
        ? widget.aboutGuide
        : "Hello, I am ${widget.name}. I am a certified professional tour guide. I love sharing ancient stories, history, and introducing tourists to our culture and beautiful hidden landmarks.";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About the Guide',
                  style: AppTextStyle.primaryTextW500S21.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Get to know ${widget.name.isNotEmpty ? widget.name : 'your guide'} and their background.',
                  style: AppTextStyle.primaryTextW400S14.copyWith(
                    color: AppColors.secondaryTextColor,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.grey200Color, thickness: 1, height: 0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  parsedBio,
                  style: AppTextStyle.primaryTextW400S16.copyWith(
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                  maxLines: _isExpanded ? null : 3,
                  overflow: _isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        _isExpanded ? 'View Less' : 'View More',
                        style: AppTextStyle.primaryW500S20.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.primaryColor,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                if (_isTourist)
                BlocConsumer<ChatInboxCubit, ChatInboxState>(
                  listener: (context, state) {
                    if (state is ChatConversationStarted) {
                      context.pushNamed(
                        AppRoutes.chatRoomScreen,
                        pathParameters: {'conversationId': state.conversation.id},
                        extra: state.conversation,
                      );
                    } else if (state is ChatStartConversationFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is ChatStartingConversation;
                    return Container(
                      width: double.infinity,
                      height: 48.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.primaryColor),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.r),
                          onTap: isLoading
                              ? null
                              : () {
                                  context
                                      .read<ChatInboxCubit>()
                                      .startConversation(
                                        otherPartyUserId: widget.guideId,
                                      );
                                },
                          child: Center(
                            child: isLoading
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primaryColor,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline_rounded,
                                        color: AppColors.primaryColor,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Contact Guide',
                                        style: AppTextStyle.primaryW500S20
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                              fontSize: 15.sp,
                                            ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
