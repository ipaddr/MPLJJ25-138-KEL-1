import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/file_pendukung.dart';
import '../../providers/file_pendukung_provider.dart';

class FormFilePendukung extends StatelessWidget {
  const FormFilePendukung({super.key});

  static const double itemWidth = 96; // width item termasuk jarak

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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ...provider.gambarList.map(
                      (item) => SizedBox(
                        width: itemWidth,
                        child: _buildItem(item),
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _buildAddButton(context),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(FilePendukung item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(item.path),
            width: 72,
            height: 72,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
          child: const Text('Tag gambar', textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final provider = Provider.of<FilePendukungProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 72,
          width: 72,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Icon(Icons.image, size: 36, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            Future.microtask(() => provider.tambahGambarDariGaleri());
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
          child: const Text('Tambah gambar', textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
