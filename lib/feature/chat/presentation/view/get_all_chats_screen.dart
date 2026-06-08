import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// قم بتعديل هذه المسارات حسب مشروعك
import 'package:smart_guide/feature/chat/data/cubit/chat_cubit.dart';
import 'package:smart_guide/feature/chat/data/cubit/chat_state.dart';
import 'package:smart_guide/feature/chat/presentation/view/widget/chat_list_app_bar.dart';
import 'package:smart_guide/feature/chat/presentation/view/widget/chat_list_empty_state.dart';
import 'package:smart_guide/feature/chat/presentation/view/widget/chat_list_item.dart';

// =============================================================================
// 1. STYLE & THEME (يفضل وضعها في ملف منفصل: chat_list_style.dart)
// =============================================================================
class ChatListStyle {
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryGradientStart = Color(0xFF6366F1);
  static const Color primaryGradientEnd = Color(0xFF4338CA);
  
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color divider = Color(0xFFF1F5F9);
  
  static const Color onlineIndicator = Color(0xFF10B981); // لون أخضر زاهي
}

// =============================================================================
// 2. UTILS (يفضل وضعها في ملف منفصل: chat_time_formatter.dart)
// =============================================================================


// =============================================================================
// 3. MAIN SCREEN (ملف: chat_list_screen.dart)
// =============================================================================
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // حماية الـ context بـ mounted لمنع الكراش
      if (mounted) {
        context.read<ChatCubit>().getConversations();
      }
    });
  }

  Future<void> _refreshChats() async {
    // حماية الـ context بـ mounted
    if (!mounted) return;
    await context.read<ChatCubit>().getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatListStyle.background,
      appBar: const ChatListAppBar(), 
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final cubit = context.read<ChatCubit>();

          if (state is GetConversationsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: ChatListStyle.primary,
                strokeWidth: 2.5,
              ),
            );
          }

          if (cubit.conversations.isEmpty) {
            return RefreshIndicator(
              color: ChatListStyle.primary,
              backgroundColor: Colors.white,
              onRefresh: _refreshChats,
              child: const ChatListEmptyState(),
            );
          }

          return RefreshIndicator(
            color: ChatListStyle.primary,
            backgroundColor: Colors.white,
            onRefresh: _refreshChats,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: cubit.conversations.length,
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(left: 88, right: 24),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: ChatListStyle.divider,
                ),
              ),
              itemBuilder: (context, index) {
                final chat = cubit.conversations[index];
                return ChatListItem(
                  chat: chat,
                  onRefresh: _refreshChats,
                ); 
              },
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
// 4. CUSTOM APP BAR (يفضل وضعها في ملف منفصل: chat_list_app_bar.dart)
// =============================================================================

// =============================================================================
// 5. EMPTY STATE WIDGET (يفضل وضعها في ملف منفصل: chat_list_empty_state.dart)
// =============================================================================


// =============================================================================
// 6. CHAT LIST ITEM WIDGET (يفضل وضعها في ملف منفصل: chat_list_item.dart)
// =============================================================================
