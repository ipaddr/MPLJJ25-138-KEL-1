import 'user.dart';
import '../config/api.dart';

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
  final User user;
  final int? fkIdProgress;

  static const String pathUrl = '$hostFilePendukung:$portFilePendukung/storage/';

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
    required this.user,
    this.fkIdProgress,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) {
    return Laporan(
      id: json['id_laporan'],
      judul: json['judul_laporan'] ?? '',
      isi: json['isi_laporan'] ?? '',
      fkIdProgress: json['fk_id_progress'] == null
        ? null
        : int.tryParse(json['fk_id_progress'].toString()),
      tanggal: DateTime.tryParse(json['tanggal_pelaporan'] ?? '') ?? DateTime.now(),
      namaPengirim: json['user']?['username'] ?? 'Anonim',
      rating: (json['rating_laporan'] != null)
          ? (json['rating_laporan'] as num).toDouble()
          : 0.0,
      namaSekolah: json['sekolah']?['nama_sekolah'] ?? 'Tidak diketahui',
      status: json['status']?['status'] ?? 'Belum diverifikasi',
      user: User.fromJson(json['user']),
      fotoUrls: (json['fotos'] as List<dynamic>? ?? []).map<String>((f) {
        final path = f['data_foto'];
        if (path is String && path.isNotEmpty) {
          return path.startsWith('http')
              ? path
              : Laporan.pathUrl + path.replaceFirst('public/', '');
        }
        return '';
      }).toList(),
      tags: (json['fotos'] as List<dynamic>? ?? []).map<String>((f) {
        return f['tag']?['nama_tag'] ?? '-';
      }).toList(),
    );
  }
  void updateRating(double newRating) {
    rating = newRating;
  }
}
