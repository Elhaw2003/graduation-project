import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/chat/data/cubit/chat_cubit.dart';
import 'package:smart_guide/feature/chat/data/cubit/chat_state.dart';
import 'package:smart_guide/feature/chat/presentation/view/widget/chat_app_bar.dart';
import 'package:smart_guide/feature/chat/presentation/view/widget/chat_input_area.dart';
import 'package:smart_guide/feature/chat/presentation/view/widget/chat_message_bubble.dart';
import 'package:smart_guide/feature/chat/presentation/view/widget/empty_chat_state.dart';

// -----------------------------------------------------------------------------
// 1. Chat Style & Colors
// -----------------------------------------------------------------------------
class ChatStyle {
  static const Color primary = Color(0xFF4F46E5);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color greyLight = Color(0xFFF1F5F9);
}

// -----------------------------------------------------------------------------
// 2. Main Chat Screen
// -----------------------------------------------------------------------------
class ChatScreen extends StatefulWidget {
  final String conversationId;

  const ChatScreen({super.key, required this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _myUserId;

  @override
  void initState() {
    super.initState();
    _initUser();
    _initChat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initUser() async {
    _myUserId = await SecureStorageHelper.instance.getUserId();
    if (mounted) setState(() {});
  }

  void _initChat() {
    final cubit = context.read<ChatCubit>();
    cubit.getMessages(widget.conversationId);
    cubit.markAsRead(widget.conversationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatStyle.background,
      appBar: const ChatAppBar(),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                final cubit = context.read<ChatCubit>();

                if (state is GetMessagesLoading && cubit.messages.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: ChatStyle.primary),
                  );
                }

                if (cubit.messages.isEmpty) {
                  return const ChatEmptyState();
                }
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: cubit.messages.length,
                  itemBuilder: (context, index) {
                    final msg =
                        cubit.messages[cubit.messages.length - 1 - index];
                    final isMe = msg.senderUserId == _myUserId;

                    return ChatBubble(message: msg, isMe: isMe);
                  },
                );
              },
            ),
          ),
          ChatInputArea(
            onSend: (text) {
              context.read<ChatCubit>().sendMessage(
                widget.conversationId,
                text,
              );
            },
          ),
        ],
      ),
    );
  }
}
