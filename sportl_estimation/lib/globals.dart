import 'dart:io';

class VideoItem {
  final String uploadTime;
  final String videoUrl;
  final String jsonFolderPathUrl;
  VideoItem({
    required this.videoUrl,
    required this.uploadTime,
    required this.jsonFolderPathUrl,
  });
}

List<VideoItem> globalVideoFiles = [];

void addVideoItem(VideoItem item) {
  globalVideoFiles.add(item);
}

void removeVideoItem(String videoUrl) {
  globalVideoFiles.removeWhere((item) => item.videoUrl == videoUrl);
}

void renameVideoItem(
    String oldVideoUrl, String newVideoUrl, String newJsonFolderPath) {
  for (var item in globalVideoFiles) {
    if (item.videoUrl == oldVideoUrl) {
      item = VideoItem(
        videoUrl: newVideoUrl,
        uploadTime: item.uploadTime,
        jsonFolderPathUrl: newJsonFolderPath,
      );
      break;
    }
  }
}
