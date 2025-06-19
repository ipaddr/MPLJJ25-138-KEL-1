import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // WAJIB untuk akses Provider
import 'package:report_school/component/card_view/card_laporan.dart';
import 'package:report_school/models/progres.dart';
import 'package:report_school/models/laporan.dart';
import 'package:report_school/providers/laporan_provider.dart';

class CardProgresDetail extends StatefulWidget {
  final Progres progres;

  const CardProgresDetail({super.key, required this.progres});

  @override
  State<CardProgresDetail> createState() => _CardProgresDetailState();
}

class _CardProgresDetailState extends State<CardProgresDetail> {
  List<Laporan> laporanList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLaporan();
  }

  Future<void> _loadLaporan() async {
    final laporanProvider = Provider.of<LaporanProvider>(context, listen: false);
    final data = await laporanProvider.fetchLaporanByProgress(widget.progres.id);
    setState(() {
      laporanList = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progres = widget.progres;
    final tanggalFormatted =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(progres.tanggal);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Laporan Terkait',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          isLoading
              ? const Center(child: CircularProgressIndicator())
              : laporanList.isEmpty
                  ? const Text("Tidak ada laporan terkait.")
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: laporanList.length,
                      itemBuilder: (context, index) {
                        return CardLaporan(laporan: laporanList[index]);
                      },
                    ),

          const SizedBox(height: 16),
          const Text(
            'Informasi Pengirim',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nama Pengirim',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9149),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(progres.namaPengirim),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        ' ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9149),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            ' ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF9149),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'Informasi Progress',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Judul Progress',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9149),
                        ),
                      ),
                      const Text(
                        'Tanggal Progress',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9149),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(progres.judul),
                      Text(tanggalFormatted),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Isi Progress',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9149),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(progres.isi ?? '-'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Persentase Progress',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9149),
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progres.persen / 100,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 4),
                  Text('${progres.persen.toStringAsFixed(1)}%'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
