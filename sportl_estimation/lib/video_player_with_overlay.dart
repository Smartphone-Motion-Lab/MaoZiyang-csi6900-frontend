import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'dart:convert'; // 确保导入 JSON 解析库
import 'package:http/http.dart' as http;
import 'dart:math';
import 'custom_painter.dart';

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
  late List<dynamic> _skeletonData = [];
  late Future<void> _initializeVideoPlayerFuture;
  double skeletonFPS = 30.0; // 骨架帧率
  bool showOverlay = true;
  int _currentFrameIndex = 0;
  double playbackSpeed = 1.0;
  double videoWidth = 0; // 视频宽度
  double videoHeight = 0; // 视频高度初始化这里
  bool isReadyToPaint = false;

  @override
  void initState() {
    super.initState();

    // 初始化视频控制器
    _initializeVideoPlayerFuture = _initializeVideoController(widget.videoUrl);

    // 加载骨架数据，异步调用骨架下载函数
    _initializeSkeletonData();
  }

  Future<void> _initializeVideoController(String videoUrl) async {
    try {
      print('正在初始化视频,URL: $videoUrl');
      _videoController = VideoPlayerController.network(videoUrl);
      await _videoController.initialize();

      // 分别获取视频的宽度和高度
      videoWidth = _videoController.value.size.width;
      videoHeight = _videoController.value.size.height;

      // 打印调试信息
      // 获取视频时长
      final Duration videoDuration = _videoController.value.duration;
      final double videoFPS = 29.75; // 假设帧率为 30 FPS

      final int totalFrames =
          (videoDuration.inMilliseconds / (1000 / videoFPS)).floor();
      print("视频宽度1: $videoWidth");
      print("视频高度1: $videoHeight");
      print("视频时长: ${_videoController.value.duration.inSeconds}s");
      print("视频总帧数: $totalFrames");

      // 检查视频尺寸
      if (videoWidth <= 0 || videoHeight <= 0) {
        print("警告：视频尺寸无效，宽: $videoWidth，高: $videoHeight");
        throw Exception("视频尺寸不可用，请检查视频路径或元数据加载是否成功");
      }

      setState(() {
        isReadyToPaint = true; // 视频和骨架数据均已准备好
      });

      _addVideoControllerListener(); // 添加监听器
    } catch (e) {
      print("视频初始化失败: $e");
    }
  }

  // 添加格式化时间的辅助方法
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void _addVideoControllerListener() {
    _videoController.addListener(() {
      // 检查视频是否已初始化
      if (!_videoController.value.isInitialized) return;
      // 获取当前播放位置
      final currentPosition = _videoController.value.position;
      _updateSkeletonFrame(currentPosition);
    });
  }

  void _updateSkeletonFrame(currentPosition) {
    // 假设视频的帧率为 30 FPS
    const double skeletonFPS = 30.0;

    final int frameIndex =
        ((currentPosition.inMilliseconds) / (1000 / skeletonFPS)).floor();

    if (_currentFrameIndex != frameIndex) {
      setState(() {
        _currentFrameIndex = frameIndex;
      });
    }
  }

  void _toggleOverlay() {
    setState(() {
      showOverlay = !showOverlay;
    });
  }

//异步调用骨架下载函数
  Future<void> _initializeSkeletonData() async {
    try {
      // 等待骨架数据下载完成
      final data = await _loadSkeletonData();
      if (data != null) {
        setState(() {
          _skeletonData = data; // 更新骨架数据
        });
      } else {
        print("骨架数据加载失败或为空");
      }
    } catch (e) {
      print("加载骨架数据时出错: $e");
    }
  }

//骨架数据下载
  Future<List<dynamic>?> _loadSkeletonData() async {
    try {
      // 发起 HTTP 请求
      print("获取骨架信息。");
      final response = await http.get(Uri.parse(widget.jsonFolderPathUrl));
      //print("Skeleton Data Response: ${response.body}"); // 打印返回的数据

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print("Loaded Skeleton Data: ${data['skeleton_data'] ?? []}");

        if (data['skeleton_data'] != null && data['skeleton_data'].isNotEmpty) {
          print("第一帧骨架数据: ${data['skeleton_data'][0]}");
          print("骨架数据总帧数: ${data['skeleton_data'].length}");
        } else {
          print("骨架数据为空");
        }
        return data['skeleton_data']; // 返回骨架数据
      } else {
        print(
            "Failed to load skeleton data. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error loading skeleton data: $e");
      return [];
    }
  }

  @override
  void dispose() {
    // 停止并清理视频控制器
    _videoController.removeListener(_addVideoControllerListener);
    _videoController.dispose();
    super.dispose();
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
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      ),
                      if (showOverlay && isReadyToPaint)
                        AspectRatio(
                          aspectRatio:
                              _videoController.value.aspectRatio, // 保持与视频一致的宽高比
                          child: CustomPaint(
                            painter: SkeletonOverlayPainter(
                              skeletonData: _skeletonData,
                              frameIndex: _currentFrameIndex,
                              videoWidth: videoWidth,
                              videoHeight: videoHeight,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                //添加时间
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(
                          _videoController.value.position), // 当前播放时间
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      _formatDuration(_videoController.value.duration), // 视频总时长
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),

                // 添加进度条
                Slider(
                  value: _videoController.value.position.inSeconds.toDouble(),
                  min: 0.0,
                  max: _videoController.value.duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _videoController.seekTo(Duration(seconds: value.toInt()));
                    });
                  },
                  onChangeEnd: (value) {
                    // 确保用户停止拖动后更新视频位置
                    _videoController.seekTo(Duration(seconds: value.toInt()));
                  },
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
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
