class Laporan {
  final String judul;
  final String deskripsi;
  final String namaPengirim;
  final DateTime tanggal;
  double rating;

  Laporan({
    required this.judul,
    this.deskripsi = '',
    required this.namaPengirim,
    required this.tanggal,
    this.rating = 0.0,
  });
}
