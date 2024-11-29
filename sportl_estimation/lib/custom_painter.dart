import 'package:flutter/material.dart';

class SkeletonOverlayPainter extends CustomPainter {
  final List<dynamic> skeletonData;
  final int frameIndex;
  final bool showCoords; // 是否显示坐标

  SkeletonOverlayPainter({
    required this.skeletonData,
    required this.frameIndex,
    this.showCoords = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (skeletonData.isNotEmpty && frameIndex < skeletonData.length) {
      var frameData = skeletonData[frameIndex];
      var people = frameData['people'];

      for (var person in people) {
        var keypoints = person['pose_keypoints_2d'];
        for (int i = 0; i < keypoints.length; i += 3) {
          double x = keypoints[i];
          double y = keypoints[i + 1];
          double confidence = keypoints[i + 2];

          if (confidence > 0.5) {
            // Transform coordinates based on video size
            double nx = x * size.width / 640; // Assuming original width is 640
            double ny =
                y * size.height / 480; // Assuming original height is 480

            // Draw keypoints
            canvas.drawCircle(Offset(nx, ny), 3, Paint()..color = Colors.red);

            // Draw coordinates text if enabled
            if (showCoords) {
              TextSpan span = new TextSpan(
                  style: new TextStyle(color: Colors.blue[800]),
                  text: "($x,$y)");
              TextPainter tp = new TextPainter(
                  text: span,
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr);
              tp.layout();
              tp.paint(canvas, Offset(nx + 5, ny + 5));
            }
          }
        }

        // Draw lines between keypoints
        _drawLines(canvas, keypoints, size);
      }
    }
  }

  void _drawLines(Canvas canvas, List<double> keypoints, Size size) {
    var paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2;

    List<List<int>> connections = [
      [0, 1], [1, 2], [2, 3], [3, 4], // Example connections
      // Add all connections here based on keypoints order
    ];

    for (var link in connections) {
      int start = link[0] * 3;
      int end = link[1] * 3;
      if (keypoints[start + 2] > 0.5 && keypoints[end + 2] > 0.5) {
        double sx = keypoints[start] * size.width / 640;
        double sy = keypoints[start + 1] * size.height / 480;
        double ex = keypoints[end] * size.width / 640;
        double ey = keypoints[end + 1] * size.height / 480;
        canvas.drawLine(Offset(sx, sy), Offset(ex, ey), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
