import 'dart:math';
import 'package:flutter/material.dart';
import '../core/tokens.dart';

class SpatialOrbVisualizer extends StatefulWidget {
  final String state; // 'idle', 'listening', 'thinking', 'speaking'
  final bool isDark;

  const SpatialOrbVisualizer({
    super.key,
    required this.state,
    this.isDark = true,
  });

  @override
  State<SpatialOrbVisualizer> createState() => _SpatialOrbVisualizerState();
}

class _SpatialOrbVisualizerState extends State<SpatialOrbVisualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: const Size(240, 240),
          painter: _OrbPainter(
            progress: _controller.value,
            state: widget.state,
            isDark: widget.isDark,
          ),
        );
      },
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double progress;
  final String state;
  final bool isDark;

  _OrbPainter({
    required this.progress,
    required this.state,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress * 2 * pi;
    final cx = size.width / 2;
    final cy = size.height / 2 - 14;
    final baseR = min(size.width, size.height) * 0.28;

    Color primary = VisionTokens.accentCyan;
    Color secondary = VisionTokens.accentViolet;
    double amp = 0.12;

    if (state == 'listening') {
      primary = VisionTokens.colorSuccess;
      secondary = VisionTokens.accentCyan;
      amp = 0.28 + 0.16 * sin(t * 4).abs();
    } else if (state == 'thinking') {
      primary = VisionTokens.accentPurple;
      secondary = VisionTokens.accentIndigo;
      amp = 0.34 + 0.12 * cos(t * 5);
    } else if (state == 'speaking') {
      primary = VisionTokens.accentCyan;
      secondary = VisionTokens.accentPurple;
      amp = 0.38 + 0.26 * (sin(t * 6) * cos(t * 3)).abs();
    } else {
      amp = 0.10 + 0.05 * sin(t * 2);
    }

    final dynamicR = baseR * (1 + amp * 0.25);

    // 1. Outer Corona
    final coronaPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primary.withOpacity(0.38),
          secondary.withOpacity(0.12),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: dynamicR * 1.9));
    canvas.drawCircle(Offset(cx, cy), dynamicR * 1.9, coronaPaint);

    // 2. Organic Multi-Layer Fluid Shell
    for (int layer = 0; layer < 3; layer++) {
      final path = Path();
      const points = 60;
      for (int i = 0; i <= points; i++) {
        final angle = (i / points) * 2 * pi;
        final wave1 = sin(angle * 3 + t * (2 + layer * 0.5) + layer);
        final wave2 = cos(angle * 5 - t * (1.5 + layer * 0.3));
        final offset = (wave1 * 0.6 + wave2 * 0.4) * (4 + amp * 14);
        final r = dynamicR * (1 - layer * 0.09) + offset;
        final x = cx + cos(angle) * r;
        final y = cy + sin(angle) * r;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();

      final paint = Paint()
        ..shader = LinearGradient(
          colors: layer == 2
              ? [Colors.white.withOpacity(0.9), primary.withOpacity(0.8)]
              : [primary.withOpacity(0.55), secondary.withOpacity(0.45)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: dynamicR));

      canvas.drawPath(path, paint);

      if (layer == 0) {
        final borderPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = Colors.white.withOpacity(isDark ? 0.36 : 0.85);
        canvas.drawPath(path, borderPaint);
      }
    }

    // 3. Mirror Audio Spectrum Bars
    const barCount = 24;
    const barW = 3.5;
    const gap = 3.5;
    const totalW = barCount * barW + (barCount - 1) * gap;
    final startX = cx - totalW / 2;
    final baseY = size.height - 10;

    for (int i = 0; i < barCount; i++) {
      final distCenter = 1 - ((i - 11.5).abs() / 11.5);
      final harmonic = sin(t * 4 + i * 0.5).abs();
      final barH = max(4.0, (0.15 + amp * 0.85) * distCenter * (10 + harmonic * 18));
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(startX + i * (barW + gap), baseY - barH, barW, barH),
        const Radius.circular(2),
      );
      canvas.drawRRect(
        rect,
        Paint()..color = i.isEven ? primary : secondary,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) => true;
}
