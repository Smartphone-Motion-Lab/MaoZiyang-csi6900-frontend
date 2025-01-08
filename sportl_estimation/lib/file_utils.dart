import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Get the application document directory and save the video file
Future<void> saveVideoFile(File videoFile) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final newFilePath = '${directory.path}/your_video.mp4';
    final newFile = await videoFile.copy(newFilePath);
    print('视频保存路径：$newFilePath');
  } catch (e) {
    print('保存视频文件时出错: $e');
  }
}
