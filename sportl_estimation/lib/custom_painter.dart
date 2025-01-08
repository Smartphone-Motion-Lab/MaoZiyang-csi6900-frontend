import 'package:flutter/material.dart';

class SkeletonOverlayPainter extends CustomPainter {
  final List<dynamic> skeletonData;
  final int frameIndex;
  final double videoWidth; // Video width
  final double videoHeight; // Video Height

  SkeletonOverlayPainter({
    required this.skeletonData,
    required this.frameIndex,
    required this.videoWidth,
    required this.videoHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Plotting the coordinate system
    _drawCoordinateSystem(canvas, size);
    // Calculating scaling
    final double xScale = size.width / videoWidth;
    final double yScale = size.height / videoHeight;
    final double confidenceThreshold = 0.5;

    // Skeleton connection rules
    final List<List<int>> connections = [
      [0, 1],
      [1, 2],
      [1, 5],
      [1, 8],
      [2, 3],
      [3, 4],
      [5, 6],
      [6, 7],
      [8, 9],
      [8, 12],
      [9, 10],
      [10, 11],
      [11, 24],
      [11, 22],
      [22, 23],
      [12, 13],
      [13, 14],
      [14, 21],
      [14, 19],
      [19, 20],
      [15, 0],
      [15, 17],
      [16, 0],
      [16, 18]
    ];

    // Current frame of skeleton data
    if (frameIndex >= skeletonData.length) return;
    final frameData = skeletonData[frameIndex];
    if (frameData.isEmpty || frameData.length % 3 != 0) return;

    final keypointPaint = Paint()..color = Colors.red;
    final connectionPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2.0;

    final Map<int, Offset> keypointPositions = {};

    for (int i = 0; i < frameData.length; i += 3) {
      final double x = frameData[i];
      final double y = frameData[i + 1];
      final double confidence = frameData[i + 2];

      if (confidence > confidenceThreshold) {
        final double nx = x * xScale;
        final double ny = y * yScale;

        canvas.drawCircle(Offset(nx, ny), 3.0, keypointPaint);
        int wx = (x / 10).floor();
        int wy = (y / 10).floor();

        final TextSpan span = TextSpan(
          style: TextStyle(color: Colors.blue[800]),
          text: "($wx, $wy)",
        );
        final TextPainter textPainter = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(nx + 5, ny + 5));

        keypointPositions[i ~/ 3] = Offset(nx, ny);
      }
    }

    for (final connection in connections) {
      final int startIdx = connection[0];
      final int endIdx = connection[1];

      if (keypointPositions.containsKey(startIdx) &&
          keypointPositions.containsKey(endIdx)) {
        canvas.drawLine(
          keypointPositions[startIdx]!,
          keypointPositions[endIdx]!,
          connectionPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void _drawCoordinateSystem(Canvas canvas, Size size) {
  final Paint axisPaint = Paint()
    ..color = const Color.fromARGB(255, 2, 239, 251)
    ..strokeWidth = 2;

  final Paint paint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 1;

  canvas.drawLine(
    Offset(0, size.height),
    Offset(size.width, size.height),
    axisPaint,
  );

  canvas.drawLine(Offset(0, size.height), Offset(0, 0), axisPaint);

  for (double i = 50; i < size.width; i += 50) {
    canvas.drawLine(
      Offset(i, size.height),
      Offset(i, size.height - 10),
      paint,
    );
  }
  for (double j = 50; j < size.height; j += 50) {
    canvas.drawLine(
      Offset(0, size.height - j),
      Offset(10, size.height - j),
      paint,
    );
  }

  final TextPainter tp = TextPainter(
    text: TextSpan(
      text: "O",
      style: TextStyle(color: Colors.black, fontSize: 14),
    ),
    textDirection: TextDirection.ltr,
  );
  tp.layout();
  tp.paint(canvas, Offset(-15, size.height - 15));
}
