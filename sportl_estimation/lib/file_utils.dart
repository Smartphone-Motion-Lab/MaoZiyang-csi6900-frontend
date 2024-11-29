import 'package:path_provider/path_provider.dart';
import 'dart:io';

// 获取应用文档目录并保存视频文件
Future<void> saveVideoFile(File videoFile) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final newFilePath = '${directory.path}/your_video.mp4'; // 修改为你要保存的视频文件名
    final newFile = await videoFile.copy(newFilePath);
    print('视频保存路径：$newFilePath'); // 使用这个路径来处理视频或者显示蒙版
  } catch (e) {
    print('保存视频文件时出错: $e');
  }
}
