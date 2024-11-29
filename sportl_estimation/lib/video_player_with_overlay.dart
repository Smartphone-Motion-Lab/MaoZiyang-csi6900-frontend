// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'dart:io';

// class VideoWithOverlayPage extends StatefulWidget {
//   final String originalVideoPath;
//   final List<dynamic> skeletonData;

//   const VideoWithOverlayPage({
//     Key? key,
//     required this.originalVideoPath,
//     required this.skeletonData,
//   }) : super(key: key);

//   @override
//   _VideoWithOverlayPageState createState() => _VideoWithOverlayPageState();
// }

// class _VideoWithOverlayPageState extends State<VideoWithOverlayPage> {
//   late VideoPlayerController _videoController;
//   bool showOverlay = false;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//   }

//   Future<void> _initializeVideo() async {
//     print("Video path: ${widget.originalVideoPath}");
//     try {
//       _videoController =
//           VideoPlayerController.file(File(widget.originalVideoPath));
//       await _videoController.initialize();
//       setState(() {
//         _isLoading = false; // 加载完成
//       });
//     } catch (e) {
//       print("视频初始化时发生错误: $e");
//       setState(() {
//         _isLoading = false; // 加载失败也要隐藏加载指示器
//       });
//       _showSnackbar("视频加载失败，请检查文件路径或格式");
//     }
//   }

//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     super.dispose();
//   }

//   void _toggleOverlay() {
//     setState(() {
//       showOverlay = !showOverlay;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("视频与骨架蒙版"),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _videoController.value.isInitialized
//               ? Column(
//                   children: [
//                     Expanded(
//                       child: Stack(
//                         children: [
//                           AspectRatio(
//                             aspectRatio: _videoController.value.aspectRatio,
//                             child: VideoPlayer(_videoController),
//                           ),
//                           if (showOverlay)
//                             Positioned.fill(
//                               child: CustomPaint(
//                                 painter: SkeletonOverlayPainter(
//                                   skeletonData: widget.skeletonData,
//                                   frameIndex: widget.skeletonData.isNotEmpty
//                                       ? (_videoController.value.position
//                                                   .inMilliseconds ~/
//                                               33) %
//                                           widget.skeletonData.length
//                                       : 0,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     VideoProgressIndicator(
//                       _videoController,
//                       allowScrubbing: true,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           icon: _videoController.value.isPlaying
//                               ? const Icon(Icons.pause)
//                               : const Icon(Icons.play_arrow),
//                           onPressed: () {
//                             setState(() {
//                               _videoController.value.isPlaying
//                                   ? _videoController.pause()
//                                   : _videoController.play();
//                             });
//                           },
//                         ),
//                         SwitchListTile(
//                           title: const Text("显示骨架蒙版"),
//                           value: showOverlay,
//                           onChanged: (value) => _toggleOverlay(),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )
//               : const Center(child: Text("视频加载失败")),
//     );
//   }
// }

// class SkeletonOverlayPainter extends CustomPainter {
//   final List<dynamic> skeletonData;
//   final int frameIndex;

//   // OpenPose 25点模型的连接关系
//   final List<List<int>> skeletonConnections = [
//     [0, 1],
//     [1, 2],
//     [2, 3],
//     [3, 4],
//     [1, 5],
//     [5, 6],
//     [6, 7],
//     [1, 15],
//     [15, 9],
//     [9, 10],
//     [10, 11],
//     [15, 12],
//     [12, 13],
//     [13, 14],
//     [0, 16],
//     [0, 17],
//     [16, 18],
//     [17, 19],
//     [14, 20],
//     [14, 21],
//     [14, 22],
//     [11, 23],
//     [11, 24],
//     [11, 25]
//   ];

//   final Paint pointPaint = Paint()
//     ..color = Colors.red
//     ..strokeWidth = 2.0;

//   final Paint linePaint = Paint()
//     ..color = Colors.blue
//     ..strokeWidth = 2.0;

//   SkeletonOverlayPainter({
//     required this.skeletonData,
//     required this.frameIndex,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (skeletonData.isNotEmpty && frameIndex < skeletonData.length) {
//       final frameData = skeletonData[frameIndex];
//       final skeletons = frameData['skeletons'];

//       if (skeletons != null && skeletons.isNotEmpty) {
//         for (var skeleton in skeletons) {
//           for (int i = 0; i < skeleton.length; i += 3) {
//             double x = skeleton[i];
//             double y = skeleton[i + 1];
//             double confidence = skeleton[i + 2];

//             if ((x == 0 && y == 0 && confidence == 0) || confidence < 0.5)
//               continue;

//             x = x * size.width / 640;
//             y = y * size.height / 480;
//             canvas.drawCircle(Offset(x, y), 3.0, pointPaint);
//           }

//           for (var connection in skeletonConnections) {
//             if (connection[0] * 3 < skeleton.length &&
//                 connection[1] * 3 < skeleton.length) {
//               final start = Offset(
//                 skeleton[connection[0] * 3] * size.width / 640,
//                 skeleton[connection[0] * 3 + 1] * size.height / 480,
//               );
//               final end = Offset(
//                 skeleton[connection[1] * 3] * size.width / 640,
//                 skeleton[connection[1] * 3 + 1] * size.height / 480,
//               );
//               canvas.drawLine(start, end, linePaint);
//             }
//           }
//         }
//       }
//     } else {
//       print("frameIndex 超出范围或 skeletonData 格式不正确");
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'dart:io';

// class VideoWithOverlayPage extends StatefulWidget {
//   final String originalVideoPath;
//   final List<dynamic> skeletonData;

//   const VideoWithOverlayPage({
//     Key? key,
//     required this.originalVideoPath,
//     required this.skeletonData,
//   }) : super(key: key);

//   @override
//   _VideoWithOverlayPageState createState() => _VideoWithOverlayPageState();
// }

// class _VideoWithOverlayPageState extends State<VideoWithOverlayPage> {
//   late VideoPlayerController _videoController;
//   bool showOverlay = false;
//   double playbackSpeed = 1.0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//   }

//   Future<void> _initializeVideo() async {
//     _videoController =
//         VideoPlayerController.file(File(widget.originalVideoPath));

//     await _videoController.initialize();
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     super.dispose();
//   }

//   void _toggleOverlay() {
//     setState(() {
//       showOverlay = !showOverlay;
//     });
//   }

//   void _changePlaybackSpeed(double speed) {
//     setState(() {
//       playbackSpeed = speed;
//       _videoController.setPlaybackSpeed(speed);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("视频与骨架蒙版"),
//       ),
//       body: _videoController.value.isInitialized
//           ? Column(
//               children: [
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       AspectRatio(
//                         aspectRatio: _videoController.value.aspectRatio,
//                         child: VideoPlayer(_videoController),
//                       ),
//                       if (showOverlay)
//                         Positioned.fill(
//                           child: CustomPaint(
//                             painter: SkeletonOverlayPainter(
//                               skeletonData: widget.skeletonData,
//                               frameIndex: (_videoController
//                                           .value.position.inMilliseconds ~/
//                                       33) %
//                                   widget.skeletonData.length,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     IconButton(
//                       icon: _videoController.value.isPlaying
//                           ? const Icon(Icons.pause)
//                           : const Icon(Icons.play_arrow),
//                       onPressed: () {
//                         setState(() {
//                           _videoController.value.isPlaying
//                               ? _videoController.pause()
//                               : _videoController.play();
//                         });
//                       },
//                     ),
//                     DropdownButton<double>(
//                       value: playbackSpeed,
//                       items: [0.5, 0.75, 1.0, 1.25, 2.0]
//                           .map((speed) => DropdownMenuItem(
//                                 value: speed,
//                                 child: Text("${speed}x"),
//                               ))
//                           .toList(),
//                       onChanged: (value) {
//                         if (value != null) {
//                           _changePlaybackSpeed(value);
//                         }
//                       },
//                     ),
//                     Switch(
//                       value: showOverlay,
//                       onChanged: (value) => _toggleOverlay(),
//                       activeColor: Colors.blue,
//                     ),
//                   ],
//                 ),
//               ],
//             )
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }
// }

// class SkeletonOverlayPainter extends CustomPainter {
//   final List<dynamic> skeletonData;
//   final int frameIndex;

//   final Paint pointPaint = Paint()
//     ..color = Colors.red
//     ..strokeWidth = 3.0;

//   final Paint linePaint = Paint()
//     ..color = Colors.blue
//     ..strokeWidth = 2.0;

//   SkeletonOverlayPainter(
//       {required this.skeletonData, required this.frameIndex});

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (skeletonData.isEmpty || frameIndex >= skeletonData.length) return;

//     final frameData = skeletonData[frameIndex];
//     final skeletons = frameData['people'];

//     for (var person in skeletons) {
//       final keypoints = person['pose_keypoints_2d'];
//       for (int i = 0; i < keypoints.length; i += 3) {
//         double x = keypoints[i] * size.width / 640;
//         double y = keypoints[i + 1] * size.height / 480;
//         double confidence = keypoints[i + 2];

//         if (confidence >= 0.5) {
//           canvas.drawCircle(Offset(x, y), 5.0, pointPaint);
//         }
//       }

//       // 绘制骨架连接线（如需根据OpenPose连接模型连接点）
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'dart:convert'; // 确保导入 JSON 解析库
import 'package:http/http.dart' as http;
import 'dart:math';

class VideoWithOverlayPage extends StatefulWidget {
  final String videoUrl;
  final String jsonFolderPathUrl;

  const VideoWithOverlayPage({
    Key? key,
    required this.videoUrl,
    required this.jsonFolderPathUrl,
  }) : super(key: key);

  @override
  _VideoWithOverlayPageState createState() => _VideoWithOverlayPageState();
}

class _VideoWithOverlayPageState extends State<VideoWithOverlayPage> {
  late VideoPlayerController _videoController;
  late List<dynamic> _skeletonData;
  bool showOverlay = true;
  double playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _loadSkeletonData();
  }

  Future<void> _initializeVideo() async {
    print(
        '视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音视频发声音: ${widget.videoUrl}'); // 打印 URL 到控制台
    _videoController = VideoPlayerController.network(widget.videoUrl);
    await _videoController.initialize();
    setState(() {});
  }

  Future<void> _loadSkeletonData() async {
    print(
        "加载 骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据骨架数据");
    print("Request URL: ${widget.jsonFolderPathUrl}"); // 打印请求的 URL
    try {
      final response = await http.get(Uri.parse(widget.jsonFolderPathUrl));
      print("Skeleton Data Response: ${response.body}"); // 在这里打印返回的数据
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _skeletonData = data['skeleton_data'] ?? [];
        });
        print("Loaded Skeleton Data: $_skeletonData");
        print(
            "Loaded Skeleton Data: ${_skeletonData.isNotEmpty ? _skeletonData[0] : 'No data loaded'}");
      } else {
        setState(() {
          _skeletonData = [];
        });
        print(
            "Failed to load skeleton data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _skeletonData = [];
      });
      print("Error loading skeleton data: $e");
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _toggleOverlay() {
    setState(() {
      showOverlay = !showOverlay;
    });
  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
      playbackSpeed = speed;
      _videoController.setPlaybackSpeed(speed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("视频与骨架蒙版"),
      ),
      body: _videoController.value.isInitialized
          ? Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      ),
                      if (showOverlay)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.3), // 添加透明背景
                            child: CustomPaint(
                              painter: SkeletonOverlayPainter(
                                skeletonData: _skeletonData,
                                frameIndex: (_videoController
                                            .value.position.inMilliseconds ~/
                                        33) %
                                    (_skeletonData.isEmpty
                                        ? 1
                                        : _skeletonData.length),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: _videoController.value.isPlaying
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow),
                      onPressed: () {
                        setState(() {
                          _videoController.value.isPlaying
                              ? _videoController.pause()
                              : _videoController.play();
                        });
                      },
                    ),
                    DropdownButton<double>(
                      value: playbackSpeed,
                      items: [0.5, 0.75, 1.0, 1.5, 2.0]
                          .map((speed) => DropdownMenuItem(
                                value: speed,
                                child: Text("${speed}x"),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _changePlaybackSpeed(value);
                        }
                      },
                    ),
                    Switch(
                      value: showOverlay,
                      onChanged: (value) => _toggleOverlay(),
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class SkeletonOverlayPainter extends CustomPainter {
  final List<dynamic> skeletonData;
  final int frameIndex;

  final Paint pointPaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 3.0;

  final Paint linePaint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 2.0;

  SkeletonOverlayPainter({
    required this.skeletonData,
    required this.frameIndex,
  });

  final List<List<int>> openPoseConnections = [
    [0, 1], [1, 2], [2, 3], [3, 4], // 上半身右侧
    [1, 5], [5, 6], [6, 7], // 上半身左侧
    [1, 8], [8, 9], [9, 10], // 右腿
    [1, 11], [11, 12], [12, 13], // 左腿
    [0, 14], [14, 16], // 右眼到右耳
    [0, 15], [15, 17], // 左眼到左耳
    [8, 11], // 骨盆连接
    [8, 24], [11, 24], [24, 1], // 骨盆中心与左右臀部及脖子的连接
    [20, 21], [22, 23], // 左右脚
    [10, 22], [13, 20] // 脚部连接
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (skeletonData.isEmpty || frameIndex >= skeletonData.length) return;

    // 获取当前帧数据
    final List<dynamic> keypoints = skeletonData[frameIndex];
    if (keypoints.length % 3 != 0) return; // 确保关键点数据有效

    // 计算屏幕缩放比例
    double xScale = size.width / 640; // 假设视频宽度为 640
    double yScale = size.height / 480; // 假设视频高度为 480
    // 解析并绘制关键点
    List<Offset> points = [];
    for (int i = 0; i < keypoints.length; i += 3) {
      double x = keypoints[i] * xScale;
      double y = keypoints[i + 1] * yScale;
      double confidence = keypoints[i + 2]; // 验证长度是否是 3 的倍数

      if (confidence > 0.5) {
        Offset point = Offset(x, y);
        points.add(point);
        // 绘制关键点
        canvas.drawCircle(point, 5.0, pointPaint);

        // 绘制坐标文本
        final textPainter = TextPainter(
          text: TextSpan(
            text: "(${x.toStringAsFixed(1)}, ${y.toStringAsFixed(1)})",
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, point.translate(5, -10)); // 偏移位置，避免覆盖点
      } else {
        points.add(Offset.zero); // 如果置信度低，标记为零点
      }
    }

    // 绘制骨架连接
    for (var connection in openPoseConnections) {
      if (connection[0] < points.length && connection[1] < points.length) {
        final start = points[connection[0]];
        final end = points[connection[1]];
        if (start != Offset.zero && end != Offset.zero) {
          canvas.drawLine(start, end, linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
