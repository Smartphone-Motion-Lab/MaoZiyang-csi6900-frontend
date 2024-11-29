import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'generated/l10n.dart';

class MyImagePicker extends StatefulWidget {
  const MyImagePicker({super.key});

  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  bool _isPicking = false; // 用于跟踪 ImagePicker 的状态

  Future<void> _pickImage() async {
    if (_isPicking) return; // 如果 ImagePicker 正在工作，则直接返回

    setState(() {
      _isPicking = true; // 标记为正在工作
    });
    try {
      final XFile? selectedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        setState(() {
          _image = selectedImage;
        });
      }
    } catch (e) {
      print('Error picking image: $e'); // 捕获并打印异常
    } finally {
      setState(() {
        _isPicking = false; // 操作完成后，重置状态
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).select_image), // AppBar标题中文化
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(S.of(context).select_image_from_album), // 按钮文字中文化
            ),
            if (_image != null)
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  S.of(context).image_selected_image_path(_image!.path),
                ), // 显示选中图片路径的文本中文化
              )
          ],
        ),
      ),
    );
  }
}
