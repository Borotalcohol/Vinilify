import 'dart:io';

import 'package:Vinilify/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '/models/vinyl.dart';
import '/utils/validators.dart' as validators;
import '/services/database.dart';
import '/widgets/button.dart';
import '/widgets/image_picker.dart';
import '/widgets/input_field_block.dart';

class EditVinylPage extends StatefulWidget {
  final Vinyl vinyl;
  final Future<void> Function() updateData;

  const EditVinylPage(
      {super.key, required this.vinyl, required this.updateData});

  @override
  State<EditVinylPage> createState() => _EditVinylPageState();
}

class _EditVinylPageState extends State<EditVinylPage> {
  final _formKey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  File? _image;
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.vinyl.title;
    _authorController.text = widget.vinyl.author;
    _yearController.text = widget.vinyl.yearOfRelease.toString();

    if (widget.vinyl.notes != null) _noteController.text = widget.vinyl.notes!;

    if (widget.vinyl.coverImageUrl != null) {
      File(widget.vinyl.coverImageUrl!).exists().then((exists) {
        if (exists) setState(() => _image = File(widget.vinyl.coverImageUrl!));
      });
    }
  }

  void _editVinyl(BuildContext context) async {
    VinylDatabase vinylDatabase = VinylDatabase();

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

      await vinylDatabase
          .updateVinyl(widget.vinyl.id!, newVinyl)
          .then((result) {
        if (result > 0) {
          // Vinyl inserted successfully

          // Update data
          widget.updateData();

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
                  Text('Vinile modificato con successo!'),
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

  void _updateChangedState() {
    bool changed = true;

    String title = _titleController.text;
    String author = _authorController.text;
    String yearOfRelease = _yearController.text;
    String? notes = _noteController.text;
    String? imagePath = _image?.path;

    changed &= title == widget.vinyl.title;
    changed &= author == widget.vinyl.author;
    changed &= yearOfRelease == widget.vinyl.yearOfRelease.toString();
    changed &= notes == widget.vinyl.notes;
    changed &= imagePath == widget.vinyl.coverImageUrl;

    setState(() {
      _changed = !changed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const TopBar(
        isFirstPage: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Divider(
                height: 1,
                color: Color.fromARGB(255, 220, 220, 220),
              ),
              Expanded(
                  child: SingleChildScrollView(
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
                            "Modifica vinile",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          /*IconButton(
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Color(0xFF999999),
                            ),
                            iconSize: 32.0,
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

                          _updateChangedState();
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
                            placeholder: "Inserisci il titolo del vinile",
                            validator: validators.titleValidator,
                            controller: _titleController,
                            onChanged: (value) => _updateChangedState(),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          InputFieldBlock(
                            label: "Autore *",
                            placeholder: "Inserisci qui l'autore",
                            validator: validators.authorValidator,
                            controller: _authorController,
                            onChanged: (value) => _updateChangedState(),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          InputFieldBlock(
                            label: "Anno *",
                            placeholder: "Inserisci qui l'anno di rilascio",
                            validator: validators.yearValidator,
                            controller: _yearController,
                            onChanged: (value) => _updateChangedState(),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          InputFieldBlock(
                            label: "Note",
                            placeholder: "Inserisci qui delle note aggiuntive",
                            numOfLines: 4,
                            controller: _noteController,
                            onChanged: (value) => _updateChangedState(),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Button(
                            text: "Modifica",
                            onPressed:
                                _changed ? () => _editVinyl(context) : null,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
