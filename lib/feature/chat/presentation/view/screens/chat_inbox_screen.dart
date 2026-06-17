import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/chat/data/model/conversation_model.dart';
import 'package:smart_guide/feature/chat/presentation/cubit/chat_inbox/chat_inbox_cubit.dart';
import 'package:smart_guide/feature/chat/presentation/cubit/chat_inbox/chat_inbox_states.dart';
import 'package:smart_guide/feature/chat/presentation/view/widgets/conversation_tile.dart';
import 'package:smart_guide/feature/chat/presentation/view/widgets/inbox_empty_state.dart';

class ChatInboxScreen extends StatefulWidget {
  const ChatInboxScreen({super.key});

  @override
  State<ChatInboxScreen> createState() => _ChatInboxScreenState();
}

class _ChatInboxScreenState extends State<ChatInboxScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatInboxCubit>().loadInbox();
    });
  }

  Future<void> _onRefresh() async {
    await context.read<ChatInboxCubit>().loadInbox();
  }

  Future<void> _openRoom(ConversationModel conversation) async {
    await context.pushNamed(
      AppRoutes.chatRoomScreen,
      pathParameters: {'conversationId': conversation.id},
      extra: conversation,
    );
    if (mounted) context.read<ChatInboxCubit>().loadInbox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Messages',
          style: AppTextStyle.whitePoppinsW500S24.copyWith(fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: Colors.white, size: 22.sp),
            onPressed: _onRefresh,
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: BlocBuilder<ChatInboxCubit, ChatInboxState>(
        builder: (context, state) {
          if (state is ChatInboxLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (state is ChatInboxFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 48.sp,
                      color: AppColors.grey300Color,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.grey400Color,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: _onRefresh,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ChatInboxLoaded) {
            if (state.conversations.isEmpty) {
              return RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: _onRefresh,
                child: const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: SizedBox(height: 500, child: InboxEmptyState()),
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                itemCount: state.conversations.length,
                itemBuilder: (context, index) {
                  final conv = state.conversations[index];
                  return ConversationTile(
                    conversation: conv,
                    onTap: () => _openRoom(conv),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
