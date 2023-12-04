import 'dart:io';
import 'package:flutter/material.dart';

import '/models/vinyl.dart';

class VinylItem extends StatelessWidget {
  const VinylItem({super.key, required this.vinyl});

  final Vinyl vinyl;

  Future<bool> _imageFileExists(String path) async {
    return File(path).exists();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: vinyl.coverImageUrl != null
                  ? FutureBuilder<bool>(
                      future: _imageFileExists(vinyl.coverImageUrl!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null &&
                            snapshot.data!) {
                          return Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(vinyl.coverImageUrl!)),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: const Color(0xFFC2C2C2),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              border: Border.all(
                                color: const Color(0xFFC2C2C2),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: const Icon(
                              Icons.image,
                              size: 52.0,
                              color: Color(0xFFC2C2C2),
                            ),
                          );
                        }
                      },
                    )
                  : Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        border: Border.all(
                          color: const Color(0xFFC2C2C2),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: const Icon(
                        Icons.image,
                        size: 52.0,
                        color: Color(0xFFC2C2C2),
                      ),
                    ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        5.0), // Adjust the radius as needed
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 3.0,
                          horizontal: 6.0,
                        ),
                        child: Text(
                          vinyl.yearOfRelease.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    width: 200.0,
                    child: Text(
                      vinyl.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    vinyl.author,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
