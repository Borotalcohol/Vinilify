import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> getImageFromGallery(ImagePicker picker) async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    return File(pickedFile.path);
  }

  return null;
}

Future<File?> getImageFromCamera(ImagePicker picker) async {
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

  if (pickedFile != null) {
    return File(pickedFile.path);
  }

  return null;
}
