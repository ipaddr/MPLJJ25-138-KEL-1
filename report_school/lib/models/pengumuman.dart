import 'package:report_school/models/foto_path.dart';
import 'package:flutter/widgets.dart';

class Pengumuman {
  final String judul;
  final String deskripsi;
  final DateTime tanggal;
  final FotoPath foto;

  Pengumuman({
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
    FotoPath? foto,
    }) : foto = foto ?? FotoPath(
            AssetImage("assets/dataDummy/pengumuman_dummy.jpg"),
            caption: 'Foto pengumuman',
          );
}
