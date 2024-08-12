import 'dart:ui';

import 'package:flutter/material.dart';

class DecoratedContainer extends StatelessWidget {
  final Widget? child;
  final Color strokeColor;
  final Color fillColor;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double? cornerRadius;

  const DecoratedContainer(
      {super.key,
      this.child,
      this.strokeColor = Colors.grey,
      this.fillColor = Colors.white,
      this.strokeWidth = 2.0,
      this.dashWidth = 5.0,
      this.dashSpace = 3.0,
      this.cornerRadius});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        fillColor: fillColor,
        cornerRadius: cornerRadius,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color strokeColor;
  final Color fillColor;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double? cornerRadius;

  _DashedBorderPainter(
      {required this.strokeColor,
      required this.fillColor,
      this.cornerRadius,
      required this.strokeWidth,
      required this.dashWidth,
      required this.dashSpace});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    if (cornerRadius != null) {}
    RRect rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12));
    Path path = Path()..addRRect(rect);
    canvas.drawPath(path, paint);

    paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    rect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12));
    path = Path()..addRRect(rect);
    final Path dashedPath = createDashedPath(path, dashWidth, dashSpace);
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  Path createDashedPath(Path source, double dashWidth, double dashSpace) {
    final Path dashedPath = Path();
    for (PathMetric pathMetric in source.computeMetrics()) {
      double distance = 0;
      while (distance < pathMetric.length) {
        final double end = distance + dashWidth;
        dashedPath.addPath(pathMetric.extractPath(distance, end), Offset.zero);
        distance = end + dashSpace;
      }
    }
    return dashedPath;
  }
}
