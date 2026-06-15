import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/aiGuide/presentation/cubit/ai_guide_cubit.dart';
import 'package:smart_guide/feature/aiGuide/presentation/cubit/ai_guide_states.dart';
import 'package:smart_guide/feature/aiGuide/presentation/view/widget/empty_chat_sliver.dart';
import 'package:smart_guide/feature/aiGuide/presentation/view/widgets/chat_bubble.dart';
import 'package:smart_guide/feature/aiGuide/presentation/view/widgets/chat_input.dart';
import 'package:smart_guide/feature/aiGuide/presentation/view/widgets/recommendation_card.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class AiGuideScreen extends StatefulWidget {
  const AiGuideScreen({super.key});

  @override
  State<AiGuideScreen> createState() => _AiGuideScreenState();
}

class _AiGuideScreenState extends State<AiGuideScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AiGuideCubit>().connect();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _AiGuideHeader(
              onRecommendationsTap: () =>
                  context.read<AiGuideCubit>().fetchRecommendations(),
            ),
            Expanded(
              child: BlocConsumer<AiGuideCubit, AiGuideState>(
                listener: (context, state) {
                  if (state is AiGuideReady &&
                      (state.isStreaming || state.messages.isNotEmpty)) {
                    _scrollToBottom();
                  }
                  if (state is AiGuideRecommendationsLoaded) {
                    _scrollToBottom();
                  }
                  if (state is AiGuideError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage),
                        backgroundColor: AppColors.redAppColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final messages = _extractMessages(state);
                  // 🚀 استخراج كروت الاقتراحات من الـ State بشكل صحيح ومضمون
                  final recommendations = state is AiGuideRecommendationsLoaded
                      ? state.recommendations
                      : null;

                  if (state is AiGuideConnecting) {
                    return const _ConnectingView();
                  }

                  if (state is AiGuideConnectionLost) {
                    return _ConnectionLostView(
                      onRetry: () => context.read<AiGuideCubit>().reconnect(),
                    );
                  }

                  if (messages.isEmpty && recommendations == null) {
                    return const CustomScrollView(slivers: [EmptyChatSliver()]);
                  }

                  // 🚀 تم تعديل الـ itemCount والـ الـ itemBuilder ليعرض رسائل الشات وتحتها قسم الاقتراحات مباشرة
                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                    itemCount:
                        messages.length + (recommendations != null ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (recommendations != null && index == messages.length) {
                        return _RecommendationsSection(
                          recommendations: recommendations,
                        );
                      }
                      return ChatBubble(message: messages[index]);
                    },
                  );
                },
              ),
            ),
            const ChatInputBar(),
          ],
        ),
      ),
    );
  }

  List<ChatMessage> _extractMessages(AiGuideState state) {
    if (state is AiGuideReady) return state.messages;
    if (state is AiGuideConnectionLost) return state.messages;
    if (state is AiGuideRecommendationsLoaded) return state.messages;
    if (state is AiGuideError) return state.messages;
    return [];
  }
}

class _AiGuideHeader extends StatelessWidget {
  final VoidCallback onRecommendationsTap;
  const _AiGuideHeader({required this.onRecommendationsTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                Assets.imagesSvgRobot,
                width: 24.w,
                height: 24.h,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.aiTravelCompanion.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 2.h),
                BlocBuilder<AiGuideCubit, AiGuideState>(
                  builder: (_, state) {
                    String status;
                    Color dotColor;
                    if (state is AiGuideConnecting) {
                      status = 'Connecting...';
                      dotColor = Colors.orange;
                    } else if (state is AiGuideConnectionLost) {
                      status = LocaleKeys.connection_lost.tr();
                      dotColor = AppColors.redAppColor;
                    } else if (state is AiGuideReady && state.isStreaming) {
                      status = LocaleKeys.ai_typing.tr();
                      dotColor = Colors.greenAccent;
                    } else {
                      status = 'Online • Ready to help';
                      dotColor = Colors.greenAccent;
                    }

                    return Row(
                      children: [
                        Container(
                          width: 7.r,
                          height: 7.r,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: dotColor.withOpacity(0.6),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          status,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRecommendationsTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, color: Colors.white, size: 14.sp),
                  SizedBox(width: 5.w),
                  Text(
                    'For You',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectingView extends StatelessWidget {
  const _ConnectingView();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40.r,
            height: 40.r,
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
              strokeWidth: 2.5,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Connecting to AI Guide...',
            style: TextStyle(
              color: AppColors.secondaryTextColor,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionLostView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ConnectionLostView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 52.sp,
              color: AppColors.grey300Color,
            ),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.connection_lost.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryTextColor,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
              ),
              child: const Text('Retry Connection'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationsSection extends StatelessWidget {
  final List<Map<String, dynamic>> recommendations;
  const _RecommendationsSection({required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Row(
          children: [
            Container(
              width: 4.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              LocaleKeys.recommendations.tr(),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, i) =>
                RecommendationCard(place: recommendations[i]),
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
