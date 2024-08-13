import 'dart:ui';

import 'package:flutter/material.dart';

class DecoratedContainer extends StatelessWidget {
  /// The [child] contained by the container.
  ///
  /// If null, and if the [constraints] are unbounded or also null, the
  /// container will expand to fill all available space in its parent, unless
  /// the parent provides unbounded constraints, in which case the container
  /// will attempt to be as small as possible.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// Specifies the color of the border or stroke around the [Widget]
  final Color strokeColor;

  /// Specifies the color used to fill the inside of the  [Widget]
  final Color fillColor;

  /// How wide to make edges to be drawn. The width is given in logical pixels measured in
  /// the direction orthogonal to the direction of the path.
  ///
  /// Defaults to 0.0, which correspond to a hairline width.
  final double strokeWidth;

  /// Specifies the width of each dash in a dashed border
  final double dashWidth;

  /// Specifies the space between each dash in a dashed border
  final double dashSpace;

  /// Defines the radius of the corners for rounded shapes. If `null`, the shape has sharp corners
  final double? cornerRadius;

  /// Empty space to inscribe inside the [decoration]. The [child], if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  final EdgeInsetsGeometry? padding;

  const DecoratedContainer(
      {super.key,
      this.child,
      this.strokeColor = Colors.grey,
      this.fillColor = Colors.white,
      this.padding,
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
      child: Container(
        padding: padding,
        child: child,
      ),
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
