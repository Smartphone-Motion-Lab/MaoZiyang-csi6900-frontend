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
  bool _isPicking = false;

  Future<void> _pickImage() async {
    if (_isPicking) return;

    setState(() {
      _isPicking = true;
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
      print('Error picking image: $e');
    } finally {
      setState(() {
        _isPicking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).select_image),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(S.of(context).select_image_from_album),
            ),
            if (_image != null)
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  S.of(context).image_selected_image_path(_image!.path),
                ),
              )
          ],
        ),
      ),
    );
  }
}
