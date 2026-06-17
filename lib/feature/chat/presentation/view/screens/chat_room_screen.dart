import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/chat/data/model/chat_message_model.dart';
import 'package:smart_guide/feature/chat/data/model/conversation_model.dart';
import 'package:smart_guide/feature/chat/presentation/cubit/chat_room/chat_room_cubit.dart';
import 'package:smart_guide/feature/chat/presentation/cubit/chat_room/chat_room_states.dart';
import 'package:smart_guide/feature/chat/presentation/view/widgets/blocked_banner.dart';
import 'package:smart_guide/feature/chat/presentation/view/widgets/chat_bubble.dart';
import 'package:smart_guide/feature/chat/presentation/view/widgets/message_input_bar.dart';

class ChatRoomScreen extends StatefulWidget {
  final String conversationId;
  final ConversationModel? initialConversation;

  const ChatRoomScreen({
    super.key,
    required this.conversationId,
    this.initialConversation,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isGuide = false;

  @override
  void initState() {
    super.initState();
    _checkRole();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatRoomCubit>().loadRoom(
        conversationId: widget.conversationId,
      );
    });
  }

  Future<void> _checkRole() async {
    final type = await SecureStorageHelper.instance.getUserTypeEnum();
    if (mounted) setState(() => _isGuide = type == UserTypeEnum.TourGuide);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showCreativeSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    IconData icon = Icons.check_circle_rounded,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 2),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isError
                  ? [const Color(0xFFE53935), const Color(0xFFFF6659)]
                  : [AppColors.primaryColor, const Color(0xFF7B61FF)],
            ),
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: (isError ? Colors.red : AppColors.primaryColor)
                    .withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSend(ChatRoomLoaded loaded) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    if (loaded.editingMessage != null) {
      _textController.clear();
      context.read<ChatRoomCubit>().submitEdit(
        messageId: loaded.editingMessage!.id,
        content: text,
      );
    } else {
      _textController.clear();
      context.read<ChatRoomCubit>().sendMessage(
        conversationId: widget.conversationId,
        content: text,
      );
      _scrollToBottom();
    }
  }

  void _showMessageMenu(
    BuildContext context,
    ChatMessageModel message,
    ChatRoomLoaded loaded,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.grey200Color,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                if (message.canEdit)
                  ListTile(
                    leading: Icon(
                      Icons.edit_rounded,
                      color: AppColors.primaryColor,
                      size: 22.sp,
                    ),
                    title: Text(
                      'Edit Message',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _textController.text = message.content;
                      _textController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _textController.text.length),
                      );
                      context.read<ChatRoomCubit>().startEditing(message);
                    },
                  ),
                ListTile(
                  leading: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.redAppColor,
                    size: 22.sp,
                  ),
                  title: Text(
                    'Delete Message',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.redAppColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(context, message.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext rootContext, String messageId) {
    showDialog(
      context: rootContext,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: AppColors.redAppColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_forever_rounded,
                    color: AppColors.redAppColor,
                    size: 32.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Delete Message',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'This message will be permanently removed. Are you sure?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.grey400Color,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          side: BorderSide(color: AppColors.grey200Color),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.grey400Color,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          rootContext.read<ChatRoomCubit>().deleteMessage(
                            messageId: messageId,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redAppColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          elevation: 0,
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBlockConfirmation(
    BuildContext rootContext,
    String conversationId,
    bool isCurrentlyBlocked,
  ) {
    final isBlocking = !isCurrentlyBlocked;
    showDialog(
      context: rootContext,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: isBlocking
                        ? AppColors.redAppColor.withOpacity(0.1)
                        : AppColors.greenColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isBlocking ? Icons.block_rounded : Icons.lock_open_rounded,
                    color: isBlocking
                        ? AppColors.redAppColor
                        : AppColors.greenColor,
                    size: 32.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  isBlocking ? 'Block User' : 'Unblock User',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  isBlocking
                      ? 'This user will no longer be able to send you messages. Are you sure?'
                      : 'This user will be able to send you messages again. Continue?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.grey400Color,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          side: BorderSide(color: AppColors.grey200Color),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.grey400Color,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          if (isBlocking) {
                            rootContext.read<ChatRoomCubit>().blockConversation(
                              conversationId: conversationId,
                            );
                          } else {
                            rootContext
                                .read<ChatRoomCubit>()
                                .unblockConversation(
                                  conversationId: conversationId,
                                );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isBlocking
                              ? AppColors.redAppColor
                              : AppColors.greenColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          elevation: 0,
                        ),
                        child: Text(
                          isBlocking ? 'Block' : 'Unblock',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: _buildAppBar(),
      body: BlocConsumer<ChatRoomCubit, ChatRoomState>(
        listener: (context, state) {
          if (state is ChatRoomLoaded) {
            _scrollToBottom();
            if (state.snackBarMessage != null) {
              final msg = state.snackBarMessage!;
              final isDelete = msg.toLowerCase().contains('delet');
              final isUnblock = msg.toLowerCase().contains('unblock');
              final isBlock = msg.toLowerCase().contains('block') && !isUnblock;
              _showCreativeSnackBar(
                context,
                msg,
                isError: isBlock,
                icon: isDelete
                    ? Icons.delete_sweep_rounded
                    : isUnblock
                    ? Icons.lock_open_rounded
                    : isBlock
                    ? Icons.block_rounded
                    : Icons.check_circle_rounded,
              );
              context.read<ChatRoomCubit>().clearSnackBar();
            }
          }
        },
        builder: (context, state) {
          if (state is ChatRoomLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (state is ChatRoomFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48.sp,
                    color: AppColors.grey300Color,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: AppColors.grey400Color,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ChatRoomLoaded) {
            return Column(
              children: [
                Expanded(
                  child: state.messages.isEmpty
                      ? _EmptyChat()
                      : ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];
                            final isMine =
                                message.senderUserId == state.currentUserId;
                            return ChatBubble(
                              message: message,
                              isMine: isMine,
                              onLongPress: () =>
                                  _showMessageMenu(context, message, state),
                            );
                          },
                        ),
                ),
                if (state.conversation.isMessagingBlocked)
                  const BlockedBanner()
                else
                  MessageInputBar(
                    controller: _textController,
                    isSending: state.isSending,
                    editingMessage: state.editingMessage,
                    onSend: () => _handleSend(state),
                    onCancelEdit: () {
                      _textController.clear();
                      context.read<ChatRoomCubit>().cancelEditing();
                    },
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.secondaryColor,
      elevation: 0,
      titleSpacing: 0,
      leading: BackButton(color: Colors.white),
      title: BlocBuilder<ChatRoomCubit, ChatRoomState>(
        builder: (context, state) {
          final conversation = state is ChatRoomLoaded
              ? state.conversation
              : widget.initialConversation;

          final avatarUrl =
              (conversation?.otherPartyProfilePictureUrl?.isNotEmpty == true
                      ? conversation!.otherPartyProfilePictureUrl
                      : conversation?.profilePictureUrl)
                  ?.toHttps();

          final displayName =
              conversation?.otherPartyDisplayName?.isNotEmpty == true
              ? conversation!.otherPartyDisplayName!
              : (conversation?.fullName ?? '');

          return Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: AppColors.contanerColore,
                child: avatarUrl != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: avatarUrl,
                          width: 36.r,
                          height: 36.r,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              _initialsWidget(displayName),
                        ),
                      )
                    : _initialsWidget(displayName),
              ),
              SizedBox(width: 10.w),
              Flexible(
                child: Text(
                  displayName,
                  style: AppTextStyle.whitePoppinsW500S24.copyWith(
                    fontSize: 15.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        if (_isGuide)
          _GuidePopupMenu(
            conversationId: widget.conversationId,
            onBlockTap: (isCurrentlyBlocked) => _showBlockConfirmation(
              context,
              widget.conversationId,
              isCurrentlyBlocked,
            ),
          ),
        SizedBox(width: 4.w),
      ],
    );
  }

  Widget _initialsWidget(String name) {
    final initials = name.trim().isNotEmpty
        ? name.trim().split(' ').take(2).map((w) => w[0].toUpperCase()).join()
        : '?';
    return Text(
      initials,
      style: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 12.sp,
      ),
    );
  }
}

class _EmptyChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.waving_hand_rounded,
            size: 52.sp,
            color: AppColors.primaryColor.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            'Say hello!',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.grey400Color,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Send your first message to start the conversation.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: AppColors.grey300Color),
          ),
        ],
      ),
    );
  }
}

class _GuidePopupMenu extends StatelessWidget {
  final String conversationId;
  final void Function(bool isCurrentlyBlocked) onBlockTap;

  const _GuidePopupMenu({
    required this.conversationId,
    required this.onBlockTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      builder: (context, state) {
        if (state is! ChatRoomLoaded) return const SizedBox.shrink();
        final isBlocked = state.conversation.isMessagingBlocked;

        return PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: Colors.white, size: 22.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          onSelected: (_) => onBlockTap(isBlocked),
          itemBuilder: (_) => [
            PopupMenuItem(
              value: isBlocked ? 'unblock' : 'block',
              child: Row(
                children: [
                  Icon(
                    isBlocked ? Icons.lock_open_rounded : Icons.block_rounded,
                    color: isBlocked
                        ? AppColors.greenColor
                        : AppColors.redAppColor,
                    size: 18.sp,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    isBlocked ? 'Unblock User' : 'Block User',
                    style: TextStyle(
                      color: isBlocked
                          ? AppColors.greenColor
                          : AppColors.redAppColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
