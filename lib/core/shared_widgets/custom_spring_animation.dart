import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSpringPage extends CustomTransitionPage<void> {
  CustomSpringPage({required Widget child})
    : super(
        child: child,
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack, // تقريب للـ spring
          );

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1), // Slide from bottom
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: FadeTransition(opacity: curvedAnimation, child: child),
          );
        },
      );
}
