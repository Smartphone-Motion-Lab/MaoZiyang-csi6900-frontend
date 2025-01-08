import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'dart:convert';
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
  double skeletonFPS = 30.0;
  bool showOverlay = true;
  int _currentFrameIndex = 0;
  double playbackSpeed = 1.0;
  double videoWidth = 0;
  double videoHeight = 0;

  @override
  void initState() {
    super.initState();

    _initializeVideoController(widget.videoUrl);

    _loadSkeletonData();
  }

  Future<void> _initializeVideoController(String videoUrl) async {
    try {
      print('正在初始化视频,URL: $videoUrl');
      _videoController = VideoPlayerController.network(videoUrl);
      await _videoController.initialize();

      final double videoWidth = _videoController.value.size.width;
      final double videoHeight = _videoController.value.size.height;

      print("视频宽度1: $videoWidth");
      print("视频高度1: $videoHeight");
      print("视频时长: ${_videoController.value.duration.inSeconds}s");

      if (videoWidth <= 0 || videoHeight <= 0) {
        print("警告：视频尺寸无效，宽: $videoWidth，高: $videoHeight");
        throw Exception("视频尺寸不可用，请检查视频路径或元数据加载是否成功");
      }
      _addVideoControllerListener();
      setState(() {});
    } catch (e) {
      print("视频初始化失败: $e");
    }
  }

  void _addVideoControllerListener() {
    _videoController.addListener(() {
      if (!_videoController.value.isInitialized) return;

      final currentPosition = _videoController.value.position;
      _updateSkeletonFrame(currentPosition);
    });
  }

  void _updateSkeletonFrame(currentPosition) {
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

  Future<List<dynamic>?> _loadSkeletonData() async {
    try {
      print("获取骨架信息。");
      final response = await http.get(Uri.parse(widget.jsonFolderPathUrl));
      print("Skeleton Data Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Loaded Skeleton Data: ${data['skeleton_data'] ?? []}");

        if (data['skeleton_data'] != null && data['skeleton_data'].isNotEmpty) {
          print("第一帧骨架数据: ${data['skeleton_data'][0]}");
          print("骨架数据总帧数: ${data['skeleton_data'].length}");
        } else {
          print("骨架数据为空");
        }
        return data['skeleton_data'];
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
                      if (showOverlay)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: SkeletonOverlayPainter(
                              skeletonData: _skeletonData,
                              frameIndex: _currentFrameIndex,
                              videoWidth: _videoController.value.size.width,
                              videoHeight: _videoController.value.size.height,
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
