import 'package:flutter/material.dart';

class AnimationHelpers {
  static Widget slideInTransition(
    Widget child, {
    required Animation<double> animation,
    Offset? beginOffset,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset ?? const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuart,
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  static PageRouteBuilder<T> createRoute<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutQuart;
        
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  static Widget staggeredListItem(
    Widget child, {
    required int index,
    required bool animate,
    Duration baseDuration = const Duration(milliseconds: 300),
  }) {
    if (!animate) return child;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: baseDuration.inMilliseconds + (index * 100)),
      curve: Curves.easeOutQuart,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}