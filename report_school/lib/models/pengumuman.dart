import 'package:report_school/models/foto.dart';

class Pengumuman {
  final String judul;
  final String deskripsi;
  final DateTime tanggal;
  final Foto foto;

  Pengumuman({
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
    this.foto = const Foto(
      url: 'assets/dataDummy/pengumuman_dummy.jpg',
      caption: 'Foto pengumuman',
    ),
  });
}
