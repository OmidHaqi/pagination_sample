import 'package:flutter/material.dart';

class ShimmerLoadingEffect extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;
  final Widget? child;
  final bool clipContent;
  final BoxConstraints? constraints;
  
  const ShimmerLoadingEffect({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.child,
    this.clipContent = true,
    this.constraints,
  });

  @override
  State<ShimmerLoadingEffect> createState() => _ShimmerLoadingEffectState();
}

class _ShimmerLoadingEffectState extends State<ShimmerLoadingEffect> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
    
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(_controller);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = widget.baseColor ?? theme.colorScheme.surfaceContainerHighest.withOpacity(0.6);
    final highlightColor = widget.highlightColor ?? theme.colorScheme.surfaceContainerHighest;
    
    Widget shimmerWidget = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: FractionalOffset(_animation.value, 0),
              end: FractionalOffset(_animation.value + 1, 0),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: child,
        );
      },
      child: widget.child != null
          ? SizedBox.expand(child: widget.child)
          : null,
    );
    
    // Clip the content if needed
    if (widget.clipContent && widget.borderRadius != null) {
      shimmerWidget = ClipRRect(
        borderRadius: widget.borderRadius!,
        child: shimmerWidget,
      );
    }
    
    return Container(
      width: widget.width,
      height: widget.height,
      constraints: widget.constraints,
      child: shimmerWidget,
    );
  }
}
