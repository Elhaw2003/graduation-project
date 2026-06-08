import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/chat/data/cubit/chat_cubit.dart';
import 'package:smart_guide/feature/chat/data/cubit/chat_state.dart';
import 'package:smart_guide/feature/chat/presentation/view/chat_screen.dart';

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

                BlocConsumer<ChatCubit, ChatState>(
                  listener: (context, state) {
                    if (state is CreateConversationSuccess) {
                      debugPrint('Conversation ID: ${state.conversation.id}');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) =>
                                ChatCubit()..getMessages(state.conversation.id),
                            child: ChatScreen(
                              conversationId: state.conversation.id,
                            ),
                          ),
                        ),
                      );
                    }

                    if (state is CreateConversationError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
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
                          onTap: state is CreateConversationLoading
                              ? null
                              : () {
                                  context.read<ChatCubit>().createConversation(
                                    widget.guideId,
                                  );

                                  debugPrint('Guide ID: ${widget.guideId}');
                                },
                          child: Center(
                            child: state is CreateConversationLoading
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
