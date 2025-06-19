import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/file_pendukung_provider.dart';
import '../../models/tag_foto.dart';
import '../../models/file_pendukung.dart';

class CardFilePendukungProgress extends StatelessWidget {
  final int idProgress;
  final List<String> fotoPaths;
  final List<String> tags;

  const CardFilePendukungProgress({
    super.key,
    required this.idProgress,
    required this.fotoPaths,
    required this.tags,
  });

  static const double maxImageSizeHeight = 120.0;
  static const double maxImageSizeWidth = 200.0;

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FilePendukungProvider>(context);

    if (fotoPaths.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Tidak ada file pendukung."),
      );
    }

    final Map<String, List<String>> grouped = {};
    for (int i = 0; i < fotoPaths.length; i++) {
      final tag = (i < tags.length) ? tags[i] : "-";
      grouped.putIfAbsent(tag, () => []).add(fotoPaths[i]);
    }

    final cachedFiles = fileProvider.getCacheProgress(idProgress); // pastikan ini sama kayak getCache

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'File Pendukung',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),

        ...grouped.entries.map((entry) {
          final tag = entry.key;
          final urls = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tag: $tag", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: urls.map((path) {
                            final match = cachedFiles
                                ?.where((f) => f.path == path)
                                .cast<FilePendukung?>()
                                .firstOrNull;

                            if (match != null) {
                              return Container(
                                margin: const EdgeInsets.only(right: 12),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.memory(
                                      match.bytes,
                                      height: maxImageSizeHeight,
                                      width: maxImageSizeWidth,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              final url = fileProvider.buildImageUrl(path);
                              return FutureBuilder<bool>(
                                future: fileProvider.checkImageExistsForProgress(
                                  url,
                                  idProgress,
                                  path,
                                  TagFoto(namaTag: tag, id: 0),
                                ),
                                builder: (context, snapshot) {
                                  Widget imageWidget;

                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    imageWidget = const SizedBox(
                                      height: maxImageSizeHeight,
                                      width: maxImageSizeWidth,
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  } else if (snapshot.hasData && snapshot.data == true) {
                                    imageWidget = Image.network(
                                      url,
                                      height: maxImageSizeHeight,
                                      width: maxImageSizeWidth,
                                      fit: BoxFit.cover,
                                    );
                                  } else {
                                    imageWidget = const SizedBox(
                                      height: maxImageSizeHeight,
                                      width: maxImageSizeWidth,
                                      child: Center(child: Icon(Icons.broken_image, size: 40)),
                                    );
                                  }

                                  return Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    child: Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 2,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: imageWidget,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
