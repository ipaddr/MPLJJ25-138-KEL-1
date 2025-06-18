import 'user.dart';

class Progres {
  final int id; // <- ini sebenarnya ID dari progress (id_progress)
  final int? idLaporanTerkait; // <- fk_id_laporan (opsional)
  final String judul;
  final String? isi;
  final DateTime tanggal;
  final double persen;
  final String namaPengirim;
  final List<String>? fotoUrls;
  final List<String>? tags;
  final User user;
  final int? idProgressSebelumnya;

  static const String pathUrl = 'http://192.168.108.167:8000/storage/';

  Progres({
    required this.id,
    this.idLaporanTerkait,
    required this.judul,
    this.isi,
    required this.tanggal,
    required this.persen,
    required this.namaPengirim,
    this.fotoUrls,
    this.tags,
    required this.user,
    this.idProgressSebelumnya,
  });

  factory Progres.fromJson(Map<String, dynamic> json) {
    return Progres(
      id: json['id_progress'],
      idLaporanTerkait: json['fk_id_laporan'],
      judul: json['nama_progress'] ?? '',
      isi: json['isi_progress'],
      tanggal: DateTime.tryParse(json['tanggal_progress'] ?? '') ?? DateTime.now(),
      persen: (json['persen_progress'] != null)
          ? (json['persen_progress'] as num).toDouble()
          : 0.0,
      namaPengirim: json['user']?['username'] ?? 'Anonim',
      user: User.fromJson(json['user']),
      fotoUrls: (json['fotos'] as List<dynamic>? ?? []).map<String>((f) {
        final path = f['data_foto'];
        if (path is String && path.isNotEmpty) {
          return path.startsWith('http')
              ? path
              : Progres.pathUrl + path.replaceFirst('public/', '');
        }
        return '';
      }).toList(),
      tags: (json['fotos'] as List<dynamic>? ?? []).map<String>((f) {
        return f['tag']?['nama_tag'] ?? '-';
      }).toList(),
      idProgressSebelumnya: json['fk_id_progress_sebelumnya'],
    );
  }
}
