import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _imageFile = await _imagePicker.pickImage(source: source);

  if (_imageFile != null) {
    return await _imageFile.readAsBytes();
  }
  print('No image selected.');
}



showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 3),
    ),
  );
}