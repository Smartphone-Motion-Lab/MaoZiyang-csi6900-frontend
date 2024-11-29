import 'package:flutter/material.dart';
import 'globals.dart';
import 'video_player_with_overlay.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class VideoListPage extends StatefulWidget {
  const VideoListPage({Key? key}) : super(key: key);

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

// 获取当前用户的用户名
String? getUsername() {
  final user = FirebaseAuth.instance.currentUser;
  return user?.email; // 返回电子邮件作为用户名
}

class _VideoListPageState extends State<VideoListPage> {
  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  // 获取视频列表
  Future<void> fetchVideos() async {
    // 获取 Firebase 中的当前用户名
    String? username = getUsername();

    if (username != null) {
      final response = await http.get(
        Uri.parse('http://10.0.0.67:5000/get_videos?username=$username'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> videos = json.decode(response.body);
        setState(() {
          globalVideoFiles = videos.map((video) {
            return VideoItem(
              videoUrl: video['video_url'] ?? "未知 URL", // 修复键名
              uploadTime: video['upload_time'] ?? "未知时间",
              jsonFolderPathUrl:
                  video['jsonFolderPathUrl'] ?? "未知路径", // 修改为正确的字段名
            );
          }).toList();
        });
      } else {
        print("Failed to fetch videos. Status code: ${response.statusCode}");
      }
    } else {
      print("User is not logged in.");
    }
  }

  // 删除视频
  Future<void> deleteVideo(VideoItem video) async {
    String? username = getUsername(); // 新增代码，获取当前用户
    if (username == null) {
      print("User is not logged in.");
      return;
    }
    // 确保获取正确的文件名
    final filename = video.videoUrl.split('/').last.replaceAll('.mp4', '');
    final response = await http.post(
      Uri.parse('http://10.0.0.67:5000/delete_video'),
      body: {
        'username': username,
        'filename': filename, // 确保传递正确的文件名
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        globalVideoFiles.remove(video);
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("视频已删除")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("删除视频失败")));
    }
  }

  // 重命名视频
  Future<void> renameVideo(VideoItem video, String newFilename) async {
    String? username = getUsername(); // 新增代码，获取当前用户
    if (username == null) {
      print("User is not logged in.");
      return;
    }
    // 提取原文件名（优先使用 file.path，否则使用 videoUrl）
    final oldFilename = video.videoUrl.split('/').last.replaceAll('.mp4', '');

    if (oldFilename.isEmpty) {
      print("Error: Old filename is empty.");
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.0.67:5000/rename_video'),
      body: {
        'username': username, // 当前用户
        'old_filename': oldFilename, // 原文件名
        'new_filename': newFilename, // 新文件名
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        // 获取更新后的视频 URL 和 JSON 文件夹路径
        final newVideoUrl =
            video.videoUrl.replaceAll(oldFilename, newFilename); // 更新视频URL
        final newJsonFolderPathUrl = video.jsonFolderPathUrl
            .replaceAll(oldFilename, newFilename); // 更新JSON路径
        // 调用 renameVideoItem 以更新状态
        renameVideoItem(video.videoUrl, newVideoUrl, newJsonFolderPathUrl);
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("视频已重命名")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("重命名视频失败")));
    }
  }

  // 弹出重命名对话框
  void showRenameDialog(VideoItem video) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("重命名视频"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: "新视频名称"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("取消"),
            ),
            TextButton(
              onPressed: () async {
                String newFilename = controller.text;
                bool exists = globalVideoFiles.any((item) {
                  final filename =
                      item.videoUrl.split('/').last.replaceAll('.mp4', '');

                  return filename == newFilename;
                });

                if (newFilename.isNotEmpty && !exists) {
                  Navigator.of(context).pop();
                  await renameVideo(video, newFilename);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("文件名已存在或无效")),
                  );
                }
              },
              child: Text("确认"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("视频列表"),
      ),
      body: ListView.builder(
        itemCount: globalVideoFiles.length,
        itemBuilder: (context, index) {
          final video = globalVideoFiles[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.video_library),
              title: Text(
                // 添加了 title 属性
                video.videoUrl.split('/').last, // 显示文件名
              ),
              subtitle: Text("上传时间: ${video.uploadTime}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      print(
                          "这里这里这里这里这里这里这里这里这里这里这里这里这里这里这里这里这里这里这里[DEBUG] Navigating to VideoWithOverlayPage with JSON path: ${video.jsonFolderPathUrl}");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoWithOverlayPage(
                            videoUrl: video.videoUrl, // 视频地址
                            jsonFolderPathUrl:
                                video.jsonFolderPathUrl, // 传递骨架数据路径
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showRenameDialog(video);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await deleteVideo(video);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
