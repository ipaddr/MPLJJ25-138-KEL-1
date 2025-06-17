class Laporan {
  final int id;
  final String judul;
  final String isi;
  DateTime tanggal;
  String namaPengirim;
  double rating;
  final String namaSekolah;
  final String? status;
  final List<String> fotoUrls;
  final List<String> tags;

  static const String pathUrl = 'http://192.168.130.167:8000/storage/';

  Laporan({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tanggal,
    required this.namaPengirim,
    required this.rating,
    required this.namaSekolah,
    required this.status,
    required this.fotoUrls,
    required this.tags,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) {
    return Laporan(
      id: json['id_laporan'],
      judul: json['judul_laporan'] ?? '',
      isi: json['isi_laporan'] ?? '',
      tanggal: DateTime.tryParse(json['tanggal_pelaporan'] ?? '') ?? DateTime.now(),
      namaPengirim: json['user']?['username'] ?? 'Anonim',
      rating: (json['user'] != null && json['user']['rating'] != null)
        ? (json['user']['rating'] as num).toDouble()
        : 0.0,
      namaSekolah: json['sekolah']?['nama_sekolah'] ?? 'Tidak diketahui',
      status: json['status']?['nama_status'] ?? 'Belum diverifikasi',
      
      fotoUrls: (json['fotos'] as List<dynamic>? ?? [])
            .map<String>((f) {
              final path = f['data_foto'];
              if (path is String && path.isNotEmpty) {
                return path.startsWith('http')
                  ? path
                  : Laporan.pathUrl + path.replaceFirst('public/', '');
              }
              return ''; // fallback
            }).toList(),

        tags: (json['fotos'] as List<dynamic>? ?? [])
            .map<String>((f) => f['tag']?['nama_tag'] ?? '-')
            .toList(),

    );
  }

  void updateRating(double newRating) {
    rating = newRating;
  }

}
