import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart' as native_img_picker;

import '/utils/image_picker.dart' as image_picker;

typedef NativeImagePicker = native_img_picker.ImagePicker;

class ImagePicker extends StatefulWidget {
  final File? image;
  final Function(File) setImage;

  const ImagePicker({super.key, this.image, required this.setImage});

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  final picker = NativeImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Platform.isAndroid) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: const Text('Scatta foto'),
                    onTap: () async {
                      // close the options modal
                      Navigator.of(context).pop();
                      // get image from camera
                      await image_picker
                          .getImageFromCamera(picker)
                          .then((file) {
                        if (file != null) {
                          widget.setImage(file);
                        }
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('Carica foto'),
                    onTap: () async {
                      // close the options modal
                      Navigator.of(context).pop();
                      // get image from gallery
                      await image_picker
                          .getImageFromGallery(picker)
                          .then((file) {
                        if (file != null) {
                          widget.setImage(file);
                        }
                      });
                    },
                  ),
                  // Add more ListTiles as needed
                ],
              );
            },
          );
        } else {
          showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  child: const Text('Photo Gallery'),
                  onPressed: () async {
                    // close the options modal
                    Navigator.of(context).pop();
                    // get image from gallery
                    await image_picker.getImageFromGallery(picker).then((file) {
                      if (file != null) {
                        widget.setImage(file);
                      }
                    });
                  },
                ),
                CupertinoActionSheetAction(
                  child: const Text('Camera'),
                  onPressed: () async {
                    // close the options modal
                    Navigator.of(context).pop();
                    // get image from camera
                    await image_picker.getImageFromCamera(picker).then((file) {
                      if (file != null) {
                        widget.setImage(file);
                      }
                    });
                  },
                ),
              ],
            ),
          );
        }
      },
      child: Container(
        width: 200.0,
        height: 200.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        decoration: widget.image == null
            ? BoxDecoration(
                color: const Color(0xFFF2F2F2),
                border: Border.all(
                  color: const Color(0xFFC2C2C2),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
              )
            : BoxDecoration(
                image: DecorationImage(
                  image: FileImage(widget.image!),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: const Color(0xFFC2C2C2),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
        alignment: Alignment.center,
        child: widget.image == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    color: Color(0xFFC2C2C2),
                    size: 48.0,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Clicca qui per aggiungere un'immagine",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 136, 136, 136),
                      fontSize: 15.0,
                    ),
                  )
                ],
              )
            : null,
      ),
    );
  }
}
