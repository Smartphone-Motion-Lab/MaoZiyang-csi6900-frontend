import 'dart:io';

class VideoItem {
  final String uploadTime;
  final String videoUrl; // 视频 HTTP URL
  final String jsonFolderPathUrl; // 骨架数据路径
  VideoItem({
    required this.videoUrl,
    required this.uploadTime,
    required this.jsonFolderPathUrl, // 必填项
  });
}

List<VideoItem> globalVideoFiles = [];

// 添加视频项
void addVideoItem(VideoItem item) {
  globalVideoFiles.add(item);
}

// 删除视频项
void removeVideoItem(String videoUrl) {
  globalVideoFiles.removeWhere((item) => item.videoUrl == videoUrl);
}

// 更新视频项（如果需要支持重命名）
void renameVideoItem(
    String oldVideoUrl, String newVideoUrl, String newJsonFolderPath) {
  for (var item in globalVideoFiles) {
    if (item.videoUrl == oldVideoUrl) {
      item = VideoItem(
        videoUrl: newVideoUrl,
        uploadTime: item.uploadTime,
        jsonFolderPathUrl: newJsonFolderPath, // 修改后的参数名
      );
      break;
    }
  }
}
