class Sekolah {
  final int? idSekolah;
  final String? namaSekolah;
  final String? lokasi;

  Sekolah({this.idSekolah, this.namaSekolah, this.lokasi});

  factory Sekolah.fromJson(Map<String, dynamic> json) {
    return Sekolah(
      idSekolah: json['id_sekolah'] as int?,
      namaSekolah: json['nama_sekolah'] as String?,
      lokasi: json['lokasi'] as String?,
    );
  }
}