import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
Future<List<dynamic>?> uploadAndProcessVideo(File videoFile) async {
  try {
    final uri = Uri.parse('http://10.0.0.67:5000/process_video');
    var request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('video', videoFile.path));

    var streamedResponse = await request.send().timeout(Duration(seconds: 900));
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      // 这里直接打印接收到的数据
      //print('Received skeleton data: $responseJson');
      if (responseJson is List) {
        return responseJson; // 返回列表类型
      } else {
        print("Unexpected response format");
        return null;
      }
    } else {
      print("视频上传失败，状态码: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("上传视频时出错: $e");
    return null;
  }
}
