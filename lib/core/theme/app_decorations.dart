import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// Glass morphism card decoration
BoxDecoration glassDecoration({
  double borderRadius = 20,
  Color? color,
  double opacity = 0.06,
  bool showBorder = true,
}) {
  return BoxDecoration(
    color: color ?? Colors.white.withValues(alpha: opacity),
    borderRadius: BorderRadius.circular(borderRadius),
    border: showBorder
        ? Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1)
        : null,
  );
}

/// Gradient card decoration
BoxDecoration gradientDecoration({
  required LinearGradient gradient,
  double borderRadius = 20,
  List<BoxShadow>? shadows,
}) {
  return BoxDecoration(
    gradient: gradient,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: shadows,
  );
}

/// Glow shadow for primary elements
List<BoxShadow> primaryGlow({double opacity = 0.3, double blur = 20}) {
  return [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: opacity),
      blurRadius: blur,
      spreadRadius: 0,
    ),
  ];
}

/// Custom page transition
class FadeSlideTransition extends PageRouteBuilder {
  final Widget page;
  FadeSlideTransition({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.03);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
}

/// Haptic feedback helpers
void lightHaptic() => HapticFeedback.lightImpact();
void mediumHaptic() => HapticFeedback.mediumImpact();
void heavyHaptic() => HapticFeedback.heavyImpact();
