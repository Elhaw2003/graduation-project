import 'package:flutter/material.dart';
import 'package:smart_guide/feature/chat/presentation/view/get_all_chats_screen.dart';

class ChatListEmptyState extends StatelessWidget {
  const ChatListEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: ChatListStyle.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ChatListStyle.primary.withOpacity(0.05),
                        blurRadius: 20,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mark_chat_unread_rounded,
                    size: 64,
                    color: ChatListStyle.textLight,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "No Messages Yet",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: ChatListStyle.textDark,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Start connecting with people.\nYour conversations will show up here.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: ChatListStyle.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}