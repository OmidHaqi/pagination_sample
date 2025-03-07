import 'package:flutter/material.dart';
import 'shimmer_loading_effect.dart';

class AnimatedGridItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final bool playAnimation;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showShimmerWhileAnimating;
  
  const AnimatedGridItem({
    super.key,
    required this.child,
    required this.index,
    this.delay = Duration.zero,
    this.playAnimation = true,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeOutQuad,
    this.showShimmerWhileAnimating = true,
  });

  @override
  State<AnimatedGridItem> createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<AnimatedGridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isAnimating = true;

  @override
  void initState() {
    super.initState();
    
    // Create animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    
    // Initialize animations
    _initAnimations();
    
    _animationController.addStatusListener(_handleAnimationStatus);
    
    if (widget.playAnimation) {
      _playAnimation();
    } else {
      _animationController.value = 1.0;
      _isAnimating = false;
    }
  }

  void _initAnimations() {
    // Scale animation
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    
    // Opacity animation
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    
    // Elevation animation for Material 3 depth effect
    _elevationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    
    // Slide animation - varies by position to create visual interest
    final slideDirection = widget.index % 2 == 0 
        ? const Offset(0.0, 0.2) 
        : const Offset(0.2, 0.0);
    _slideAnimation = Tween<Offset>(
      begin: slideDirection,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _isAnimating = false;
      });
    }
  }

  Future<void> _playAnimation() async {
    if (widget.delay > Duration.zero) {
      await Future.delayed(widget.delay);
    }
    
    // Create a staggered effect based on item position
    // Using Material 3 choreography pattern - more natural feeling delay
    final double rowPosition = widget.index / 2;
    final int calculatedDelay = (widget.index % 2 == 0 ? 20 : 30) + (rowPosition * 15).toInt();
    await Future.delayed(Duration(milliseconds: calculatedDelay));
    
    if (mounted) {
      _animationController.forward();
    }
  }
  
  @override
  void didUpdateWidget(AnimatedGridItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.playAnimation != oldWidget.playAnimation) {
      if (widget.playAnimation) {
        setState(() {
          _isAnimating = true;
        });
        _animationController.reset();
        _playAnimation();
      } else {
        _animationController.animateTo(1.0, duration: const Duration(milliseconds: 150));
        setState(() {
          _isAnimating = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_handleAnimationStatus);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Show shimmer effect while loading
        if (_isAnimating && widget.showShimmerWhileAnimating && _opacityAnimation.value < 0.3) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: FractionalTranslation(
              translation: _slideAnimation.value,
              child: PhysicalModel(
                color: Colors.transparent,
                elevation: _elevationAnimation.value * 3,
                borderRadius: BorderRadius.circular(20),
                child: ShimmerLoadingEffect(
                  height: 200,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        }
        
        // Main animated container with item content
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FractionalTranslation(
            translation: _slideAnimation.value,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.08 * _elevationAnimation.value),
                    blurRadius: 8 * _elevationAnimation.value,
                    offset: Offset(0, 2 * _elevationAnimation.value),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: child,
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
