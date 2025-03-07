import 'package:flutter/material.dart';

/// Custom page transition that slides and fades in from the bottom
class SlideUpTransition extends PageRouteBuilder {
  final Widget page;
  final Duration duration;
  final Curve curve;

  SlideUpTransition({
    required this.page,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );
            
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.15),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
          transitionDuration: duration,
          reverseTransitionDuration: const Duration(milliseconds: 250),
        );
}

/// Shared axis transition from Material 3 design
class SharedAxisTransition extends PageRouteBuilder {
  final Widget page;
  final SharedAxisTransitionType transitionType;
  final Duration duration;
  final Curve curve;

  SharedAxisTransition({
    required this.page,
    this.transitionType = SharedAxisTransitionType.horizontal,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeInOut,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );
            
            // Calculate offset based on transition type
            Offset beginOffset = Offset.zero;
            switch (transitionType) {
              case SharedAxisTransitionType.horizontal:
                beginOffset = const Offset(1.0, 0.0);
                break;
              case SharedAxisTransitionType.vertical:
                beginOffset = const Offset(0.0, 1.0);
                break;
              case SharedAxisTransitionType.scaled:
                // For scaled, we'll handle it differently below
                break;
            }
            
            // Handle scale transition for the scaled type
            if (transitionType == SharedAxisTransitionType.scaled) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.90, end: 1.0).animate(curvedAnimation),
                  child: child,
                ),
              );
            } else {
              // Default slide and fade transition
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: beginOffset,
                    end: Offset.zero,
                  ).animate(curvedAnimation),
                  child: child,
                ),
              );
            }
          },
          transitionDuration: duration,
          reverseTransitionDuration: duration,
        );
}

enum SharedAxisTransitionType {
  horizontal,
  vertical,
  scaled,
}
