class Sekolah {
  final String? namaSekolah;
  final String? lokasi;

  Sekolah({this.namaSekolah, this.lokasi});

  factory Sekolah.fromJson(Map<String, dynamic> json) {
    return Sekolah(
      namaSekolah: json['nama_sekolah'] as String?,
      lokasi: json['lokasi'] as String?,
    );
  }
}