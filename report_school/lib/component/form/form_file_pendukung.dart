import 'dart:io' show File;
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/file_pendukung.dart';
import '../../providers/file_pendukung_provider.dart';
import '../window/insert_gambar_window.dart';
import '../../models/tag_foto.dart';

class FormFilePendukung extends StatelessWidget {
  const FormFilePendukung({super.key});

  static const double itemWidth = 300;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FilePendukungProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                ...provider.gambarList.map(
                  (item) => SizedBox(
                    width: itemWidth,
                    child: _ImageItem(item: item),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _buildAddButton(context, provider),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context, FilePendukungProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.all(24),
                child: UploadDokumenWindow(
                  onSubmit: (File image, TagFoto tag) async {
                    final bytes = await image.readAsBytes();

                    provider.tambahGambar(
                      FilePendukung(
                        path: image.path,
                        bytes: bytes,
                        tag: tag,
                      ),
                    );
                  },
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
          child: const Text('Tambah Gambar', textAlign: TextAlign.center),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ImageItem extends StatelessWidget {
  final FilePendukung item;
  const _ImageItem({required this.item});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (kIsWeb) {
      final base64 = base64Encode(item.bytes);
      final uri = 'data:image/png;base64,$base64';
      imageWidget = Image.network(uri, width: 300, height: 400, fit: BoxFit.cover);
    } else {
      imageWidget = Image.file(File(item.path), width: 300, height: 400, fit: BoxFit.cover);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(8), child: imageWidget),
        const SizedBox(height: 8),
        Text('Tag: ${item.tag.namaTag}', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
