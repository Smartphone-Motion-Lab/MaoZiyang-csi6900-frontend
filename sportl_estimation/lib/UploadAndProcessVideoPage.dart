import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'globals.dart'; // 存储全局数据的文件
import 'video_list_page.dart'; // 视频列表页面
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

final ImagePicker _picker = ImagePicker();

// 从图库选择视频
Future<File?> pickVideoFromGallery() async {
  final XFile? pickedFile =
      await _picker.pickVideo(source: ImageSource.gallery);
  return pickedFile != null ? File(pickedFile.path) : null;
}

// 从摄像头拍摄视频
Future<File?> captureVideoFromCamera() async {
  final XFile? capturedFile =
      await _picker.pickVideo(source: ImageSource.camera);
  return capturedFile != null ? File(capturedFile.path) : null;
}

// 上传并处理视频
Future<bool> uploadAndProcessVideo(File videoFile) async {
  try {
    final uri = Uri.parse('http://10.0.0.67:5000/process_video');
    var request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('video', videoFile.path));

    // 获取当前登录用户的邮箱
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.email ?? 'unknown_user'; // 若用户未登录，使用默认值

    // 将邮箱作为 username 字段传递给后端
    request.fields['username'] = username;

    var streamedResponse = await request.send().timeout(Duration(seconds: 900));
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      if (responseJson is Map) {
        if (responseJson['message'] == "Video processed successfully") {
          // 可选：进一步处理响应，例如存储视频 URL
          print("视频 URL: ${responseJson['videoUrl']}");
          return true; // 表示成功
        }
      }
      print("意外的响应格式");
      return false; // 表示失败
    } else {
      print("视频上传失败，状态码: ${response.statusCode}");
      return false; // 表示失败
    }
  } catch (e) {
    print("上传视频时出错: $e");
    return false; // 表示失败
  }
}

class UploadAndProcessVideoPage extends StatefulWidget {
  const UploadAndProcessVideoPage({Key? key}) : super(key: key);

  @override
  _UploadAndProcessVideoPageState createState() =>
      _UploadAndProcessVideoPageState();
}

class _UploadAndProcessVideoPageState extends State<UploadAndProcessVideoPage> {
  File? videoFile;
  VideoPlayerController? _videoController;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickVideo() async {
    videoFile = await pickVideoFromGallery();
    if (videoFile != null) {
      _initializeVideoPlayer();
    }
  }

  Future<void> _captureVideo() async {
    videoFile = await captureVideoFromCamera();
    if (videoFile != null) {
      _initializeVideoPlayer();
    }
  }

  Future<void> _initializeVideoPlayer() async {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(videoFile!)
      ..initialize().then((_) {
        setState(() {});
        _videoController!.setLooping(false);
        _videoController!.addListener(checkVideo);
      });
    _videoController!.addListener(() {
      setState(
          () {}); // Update UI any time there is a change in video controller state
    });
  }

  void checkVideo() {
    if (_videoController!.value.position == _videoController!.value.duration) {
      _videoController!.seekTo(Duration.zero);
      _videoController!.pause();
      setState(() {});
    }
  }

  Future<void> _uploadVideoAndProcess() async {
    if (videoFile == null) {
      _showSnackbar("Please select a video");
      return;
    }
    setState(() {
      _isUploading = true;
    });

    bool success = await uploadAndProcessVideo(videoFile!);

    setState(() {
      _isUploading = false;
    });

    if (success) {
      _showSnackbar("Video processing completed");
    } else {
      _showSnackbar("Video Processing Failure");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Uploading and processing videos")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (videoFile != null &&
                  _videoController != null &&
                  _videoController!.value.isInitialized)
                Column(
                  children: [
                    AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                    VideoProgressIndicator(_videoController!,
                        allowScrubbing: true),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(_videoController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow),
                          onPressed: () => setState(() {
                            _videoController!.value.isPlaying
                                ? _videoController!.pause()
                                : _videoController!.play();
                          }),
                        ),
                        IconButton(
                          icon: const Icon(Icons.speed),
                          onPressed: () => setState(() {
                            _videoController!.setPlaybackSpeed(
                                _videoController!.value.playbackSpeed == 2.0
                                    ? 1.0
                                    : 2.0);
                          }),
                        ),
                        Text(
                            "${formatDuration(_videoController!.value.position)} / ${formatDuration(_videoController!.value.duration)}"),
                      ],
                    ),
                  ],
                ),
              ElevatedButton(
                onPressed: _pickVideo,
                child: const Text("Select video from gallery"),
              ),
              ElevatedButton(
                onPressed: _captureVideo,
                child: const Text("Shooting Video"),
              ),
              ElevatedButton(
                onPressed: _uploadVideoAndProcess,
                child: const Text("Upload and process video"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VideoListPage())),
                child: const Text("View the list of videos"),
              ),
              if (_isUploading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}
