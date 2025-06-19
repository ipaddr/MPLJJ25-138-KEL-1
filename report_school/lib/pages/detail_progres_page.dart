import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../component/card_view/card_file_pendukung_progress.dart';
import '../component/card_view/card_progres_detail.dart';
import '../providers/get_progres_detail_provider.dart';

class DetailProgresPage extends StatefulWidget {
  final int progresId;

  const DetailProgresPage({super.key, required this.progresId});

  @override
  State<DetailProgresPage> createState() => _DetailProgresPageState();
}

class _DetailProgresPageState extends State<DetailProgresPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      final provider = Provider.of<GetDetailProgresProvider>(context, listen: false);
      provider.fetchProgresDetail(widget.progresId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Progres'),
        centerTitle: true,
      ),
      body: Consumer<GetDetailProgresProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          final progres = provider.progres;
          if (progres == null) {
            return const Center(child: Text('Progres tidak ditemukan.'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                CardProgresDetail(progres: progres),
                CardFilePendukungProgress(
                  idProgress: progres.id,
                  fotoPaths: progres.fotoUrls ?? [],
                  tags: progres.tags ?? [],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
