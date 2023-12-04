import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '/models/vinyl.dart';
import '/services/database.dart';
import '/utils/validators.dart' as validators;
import '/widgets/input_field_block.dart';
import '/widgets/button.dart';
import '/widgets/image_picker.dart';

class AddVinylPage extends StatefulWidget {
  const AddVinylPage({super.key});

  @override
  State<AddVinylPage> createState() => _AddVinylPageState();
}

class _AddVinylPageState extends State<AddVinylPage> {
  final _formKey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _authorFocusNode = FocusNode();
  final FocusNode _yearOfReleaseFocusNode = FocusNode();
  final FocusNode _notesFocusNode = FocusNode();

  File? _image;

  void _addVinyl(BuildContext context) async {
    VinylDatabase vinylDatabase = VinylDatabase();

    _closeKeyboard();

    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      String author = _authorController.text;
      String yearOfRelease = _yearController.text;
      String? notes = _noteController.text;

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String imagePath =
          '${appDocDir.path}/vinyl_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (_image != null) {
        await _image!.copy(imagePath);
      }

      // Add new vinyl to database
      Vinyl newVinyl = Vinyl(
          coverImageUrl: _image != null ? imagePath : null,
          title: title,
          author: author,
          yearOfRelease: int.parse(yearOfRelease),
          notes: notes);

      await vinylDatabase.insertVinyl(newVinyl).then((result) {
        if (result > 0) {
          // Vinyl inserted successfully

          // Clear text fields
          setState(() {
            _image = null;
            _titleController.clear();
            _authorController.clear();
            _yearController.clear();
            _noteController.clear();
          });

          // Scroll back to the top
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );

          // Show a feedback to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.0),
                  Text('Vinile aggiunto con successo!'),
                ],
              ),
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        } else {
          // Vinyl insertion failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.0),
                  Text('Si è verificato un errore.'),
                ],
              ),
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        }
      });
    }
  }

  void _closeKeyboard() {
    _titleFocusNode.unfocus();
    _authorFocusNode.unfocus();
    _yearOfReleaseFocusNode.unfocus();
    _notesFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 50.0,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Aggiungi vinile",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                /*IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Color(0xFF999999),
                  ),
                  iconSize: 28.0,
                  onPressed: () => print("Ciao"),
                ),*/
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            ImagePicker(
              image: _image,
              setImage: (File file) {
                setState(() {
                  _image = file;
                });
              },
            ),
            const Divider(
              height: 60,
              color: Color.fromARGB(255, 220, 220, 220),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputFieldBlock(
                  label: "Titolo *",
                  placeholder: 'Inserisci qui il titolo del vinile',
                  controller: _titleController,
                  focusNode: _titleFocusNode,
                  validator: validators.titleValidator,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                InputFieldBlock(
                  label: "Autore *",
                  placeholder: 'Inserisci qui l\'autore',
                  controller: _authorController,
                  focusNode: _authorFocusNode,
                  validator: validators.authorValidator,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                InputFieldBlock(
                  label: "Anno *",
                  placeholder: 'Inserisci qui l\'anno di rilascio',
                  controller: _yearController,
                  focusNode: _yearOfReleaseFocusNode,
                  validator: validators.yearValidator,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                InputFieldBlock(
                  label: "Note",
                  placeholder: 'Inserisci qui delle note aggiuntive',
                  controller: _noteController,
                  focusNode: _notesFocusNode,
                  numOfLines: 4,
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Button(
                  text: "Aggiungi",
                  onPressed: () => _addVinyl(context),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
