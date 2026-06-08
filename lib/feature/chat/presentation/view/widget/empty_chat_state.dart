import 'package:flutter/material.dart';
import 'package:smart_guide/feature/chat/presentation/view/chat_screen.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: ChatStyle.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.waving_hand_rounded,
              size: 40,
              color: Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Say hello!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ChatStyle.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Start the conversation by sending a message.",
            style: TextStyle(fontSize: 14, color: ChatStyle.textMuted),
          ),
        ],
      ),
    );
  }
}
