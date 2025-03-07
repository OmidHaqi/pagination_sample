import 'package:flutter/material.dart';
import 'dart:math' as math;

class CreativeLoadingIndicator extends StatefulWidget {
  final double size;
  
  const CreativeLoadingIndicator({
    super.key,
    this.size = 50.0,
  });

  @override
  State<CreativeLoadingIndicator> createState() => _CreativeLoadingIndicatorState();
}

class _CreativeLoadingIndicatorState extends State<CreativeLoadingIndicator> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final tertiaryColor = theme.colorScheme.tertiary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer circle
                Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: CircleSegmentPainter(
                      color: primaryColor,
                      startAngle: 0,
                      sweepAngle: 0.8 * math.pi,
                      strokeWidth: widget.size * 0.08,
                    ),
                  ),
                ),
                
                // Middle circle
                Transform.rotate(
                  angle: -_controller.value * 2 * math.pi,
                  child: CustomPaint(
                    size: Size(widget.size * 0.7, widget.size * 0.7),
                    painter: CircleSegmentPainter(
                      color: secondaryColor,
                      startAngle: 0.5 * math.pi,
                      sweepAngle: 0.9 * math.pi,
                      strokeWidth: widget.size * 0.08,
                    ),
                  ),
                ),
                
                // Inner circle
                Transform.rotate(
                  angle: _controller.value * 3 * math.pi,
                  child: CustomPaint(
                    size: Size(widget.size * 0.4, widget.size * 0.4),
                    painter: CircleSegmentPainter(
                      color: tertiaryColor,
                      startAngle: 1.0 * math.pi,
                      sweepAngle: 1.1 * math.pi,
                      strokeWidth: widget.size * 0.08,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CircleSegmentPainter extends CustomPainter {
  final Color color;
  final double startAngle;
  final double sweepAngle;
  final double strokeWidth;
  
  CircleSegmentPainter({
    required this.color,
    required this.startAngle,
    required this.sweepAngle,
    required this.strokeWidth,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
      
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }
  
  @override
  bool shouldRepaint(CircleSegmentPainter oldDelegate) {
    return oldDelegate.color != color ||
           oldDelegate.startAngle != startAngle ||
           oldDelegate.sweepAngle != sweepAngle ||
           oldDelegate.strokeWidth != strokeWidth;
  }
}
