enum FileTypePendukung { gambar}

class FilePendukung {
  final String path;
  final FileTypePendukung tipe;

  FilePendukung({
    required this.path,
    required this.tipe,
  });
}
