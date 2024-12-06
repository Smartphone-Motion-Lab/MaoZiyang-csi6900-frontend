import 'package:flutter/material.dart';
import 'video_player_with_overlay.dart';

class SkeletonOverlayPainter extends CustomPainter {
  final List<dynamic> skeletonData;
  final int frameIndex;
  final double videoWidth; // 添加视频宽度
  final double videoHeight; // 添加视频高度

  SkeletonOverlayPainter({
    required this.skeletonData,
    required this.frameIndex,
    required this.videoWidth, // 构造函数初始化宽度
    required this.videoHeight, // 构造函数初始化高度
  });

  @override
  void paint(Canvas canvas, Size size) {
    print("此处开始调用绘图函数");
    // 计算缩放比例
    final double xScale = size.width / videoWidth;
    final double yScale = size.height / videoHeight;
    final double confidenceData = 0.5;
    print("视频宽度2: $videoWidth");
    print("视频高度2: $videoHeight");
    print("xScale: ${size.width}, yScale: $videoWidth");
    print("xScale: ${size.height}, yScale: $videoHeight");
    print("正在绘制的帧：${frameIndex}");
    var frameData = skeletonData[frameIndex];

    print("此处开始调用骨架线");
    print("正在使用的骨架线: ${frameData}");

    for (int i = 0; i < frameData.length; i += 3) {
      double x = frameData[i];
      double y = frameData[i + 1];
      double confidence = frameData[i + 2];

      if (confidence > confidenceData) {
        // Transform coordinates based on video size
        double nx = x * xScale; // Assuming original width is 640
        double ny = y * yScale; // Assuming original height is 480

        // Draw keypoints
        canvas.drawCircle(Offset(nx, ny), 3, Paint()..color = Colors.red);

        // Draw coordinates text if enabled

        TextSpan span = new TextSpan(
            style: new TextStyle(color: Colors.blue[800]), text: "($x,$y)");
        TextPainter tp = new TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, Offset(nx + 5, ny + 5));
      }
    }

    var paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2;

    // 定义骨架的连接规则
    final List<List<int>> connections = [
      // 躯干部分
      [0, 1], [1, 2], [1, 5], [1, 8], [2, 3], // 鼻子到脖子，脖子到肩膀和臀部

      // 右臂
      [3, 4], [5, 6], // 右肩到右肘，右肘到右手腕

      // 左臂
      [6, 7], [8, 9], // 左肩到左肘，左肘到左手腕

      // 右腿
      [8, 12], [9, 10], // 右臀部到右膝盖，右膝盖到右脚踝

      // 左腿
      [10, 11], [11, 24], // 左臀部到左膝盖，左膝盖到左脚踝

      // 脸部
      [11, 22], [22, 23], [12, 13], [13, 14], // 鼻子到眼睛，眼睛到耳朵

      // 脚部连接
      [14, 21], [14, 19], [19, 20], // 右脚大脚趾、小脚趾及连接
      [15, 0], [15, 17], [16, 0], // 左脚大脚趾、小脚趾及连接
      [16, 18]
    ];

    for (var connection in connections) {
      int startIdx = connection[0] * 3;
      int endIdx = connection[1] * 3;

      if (frameData[startIdx + 2] > confidenceData &&
          frameData[endIdx + 2] > confidenceData) {
        // 获取起点坐标
        double startX = frameData[startIdx] * xScale;
        double startY = frameData[startIdx + 1] * yScale;

        // 获取终点坐标
        double endX = frameData[endIdx] * xScale;
        double endY = frameData[endIdx + 1] * yScale;

        // 绘制线
        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
