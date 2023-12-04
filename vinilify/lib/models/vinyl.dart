class Vinyl {
  final int? id;
  final String? coverImageUrl;
  final String title;
  final String author;
  final int yearOfRelease;
  final String? notes;

  Vinyl({
    this.id,
    required this.coverImageUrl,
    required this.title,
    required this.author,
    required this.yearOfRelease,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'yearOfRelease': yearOfRelease,
      'notes': notes,
      'coverImageUrl': coverImageUrl,
    };
  }

  @override
  String toString() {
    return 'Vinyl {id: $id, title: $title, author: $author, yearOfRelease: ${yearOfRelease.toString()}, coverImageUrl: ${coverImageUrl ?? "No image URL"}}';
  }
}
