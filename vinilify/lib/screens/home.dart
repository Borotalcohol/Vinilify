import 'dart:async';

import 'package:flutter/material.dart';

import '/models/vinyl.dart';
import '/services/database.dart';
import '/widgets/vinyl_item.dart';
import '/screens/edit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.vinyls, required this.updateData});
  final List<Vinyl> vinyls;
  final Future<void> Function() updateData;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Vinyl> _filteredVinyls = [];
  bool deleteLoading = false;

  @override
  void initState() {
    super.initState();
    _filterVinyls(_searchController.text);
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _filterVinyls(_searchController.text);
  }

  void _filterVinyls(String query) {
    setState(() {
      _filteredVinyls = query != ""
          ? widget.vinyls
              .where((vinyl) =>
                  vinyl.title.toLowerCase().contains(query.toLowerCase()) ||
                  vinyl.author.toLowerCase().contains(query.toLowerCase()) ||
                  vinyl.yearOfRelease.toString().contains(query.toLowerCase()))
              .toList()
          : widget.vinyls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "I tuoi vinili (${widget.vinyls.length})",
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
            height: 20.0,
          ),
          Text(
            "Ricerca",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _searchController,
            onChanged: _filterVinyls,
            autofocus: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF2F2F2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Color(0xFFCECECE),
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Color(0xFFCECECE), // Border color
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 171, 171, 171), // Border color
                  width: 1.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              hintText: 'Inserisci qui il titolo del vinile',
              hintStyle: const TextStyle(
                color: Color(0xFF8D8D8D),
                fontSize: 16.0,
              ),
              suffixIcon: const Icon(
                Icons.search,
                color: Color(0xFFCECECE),
                size: 24.0,
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredVinyls.length,
              itemBuilder: (context, index) {
                Vinyl vinyl = _filteredVinyls[index];
                return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        size: 36.0,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            title: Text(
                              deleteLoading
                                  ? "Eliminazione in corso..."
                                  : "Conferma eliminazione",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: deleteLoading
                                ? SizedBox(
                                    height: 100.0,
                                    width: 100.0,
                                    child: Center(
                                      child: Transform.scale(
                                        scale: 1.4,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 3.0,
                                        ),
                                      ),
                                    ),
                                  )
                                : const Text(
                                    "Sei sicuro di voler eliminare questo vinile? Quest'azione è irreversibile",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                            actions: !deleteLoading
                                ? <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text(
                                        "Elimina",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text(
                                        "Annulla",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xAA272727),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ]
                                : [],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) async {
                      setState(() {
                        deleteLoading = true;
                      });

                      VinylDatabase vinylDb = VinylDatabase();

                      await vinylDb.deleteVinyl(vinyl.id!).then((res) async {
                        if (res > 0) {
                          // Vinyl actually deleted

                          // Update vinyls
                          await widget.updateData().then((_) {
                            setState(() {
                              deleteLoading = false;
                            });

                            // Show graphical feedback to user
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text('Vinile eliminato con successo!'),
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
                          });
                        } else {
                          // Error while deleting vinyls
                          setState(() {
                            deleteLoading = false;
                          });

                          // Show graphical feedback to user
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
                    },
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditVinylPage(
                                  vinyl: vinyl, updateData: widget.updateData),
                            ),
                          );
                        },
                        child: VinylItem(vinyl: vinyl)));
              },
              separatorBuilder: (context, index) {
                // Add a divider after each item except for the last one
                if (index < widget.vinyls.length - 1) {
                  return const Divider(
                    height: 20,
                    color: Color.fromARGB(255, 220, 220, 220),
                  );
                } else {
                  return const SizedBox
                      .shrink(); // Return an empty SizedBox for the last item
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
