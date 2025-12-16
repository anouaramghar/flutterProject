import 'package:flutter/material.dart';

PageRouteBuilder<T> buildFadeSlideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0, 0.04),
        end: Offset.zero,
      ).animate(curved);
      final fadeAnimation =
          CurvedAnimation(parent: animation, curve: Curves.easeOut);

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: offsetAnimation,
          child: child,
        ),
      );
    },
  );
}


