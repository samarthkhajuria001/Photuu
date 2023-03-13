import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  ImagePicker picker = ImagePicker();

  XFile? file =
      await picker.pickImage(source: source, imageQuality: 80, maxHeight: 480);
  if (file != null) {
    return file.readAsBytes();
  }

  print('no image slected');
}

showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text)),
  );
}
