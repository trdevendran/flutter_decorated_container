import 'dart:ui';

import 'package:flutter/material.dart';

class DecoratedContainer extends StatelessWidget {
  /// The [child] contained by the container.
  final Widget? child;

  /// Specifies the color of the border or stroke around the [Widget]
  final Color strokeColor;

  /// Specifies the color used to fill behind the child  [Widget]
  final Color backgroundColor;

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

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry? margin;

  /// To actually paint a [Decoration] at behind the [child].
  /// Use the [color] property to specify a simple solid color.
  /// Dashed/dotted border will be overlapped when this property has values.
  final Decoration? decoration;

  /// Whether to paint the box decoration behind or in front of the child.
  final DecorationPosition decorationPosition;

  const DecoratedContainer({
    super.key,
    this.child,
    this.strokeColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.padding,
    this.margin,
    this.strokeWidth = 2.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.cornerRadius,
    this.decoration,
    this.decorationPosition = DecorationPosition.background,
  });

  @override
  Widget build(BuildContext context) {
    if (decoration == null) {
      return CustomPaint(
        painter: _DashedBorderPainter(
          strokeColor: strokeColor,
          strokeWidth: strokeWidth,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
          fillColor: backgroundColor,
          cornerRadius: cornerRadius,
        ),
        child: margin == null && padding == null
            ? child
            : Container(
                decoration: decoration,
                padding: padding,
                margin: margin,
                child: child,
              ),
      );
    }
    if (padding == null && margin == null && decoration != null) {
      return DecoratedBox(decoration: decoration!, child: child);
    }
    return Container(
      decoration: decoration,
      padding: padding,
      margin: margin,
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
