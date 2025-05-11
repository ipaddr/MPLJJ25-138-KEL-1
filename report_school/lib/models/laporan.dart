class Laporan {
  final String judul;
  final String deskripsi;
  final String namaPengirim;
  final DateTime tanggal;
  int rating;

  Laporan({
    required this.judul,
    required this.deskripsi,
    required this.namaPengirim,
    required this.tanggal,
    this.rating = 0,
  });
}
