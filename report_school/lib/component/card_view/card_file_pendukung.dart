import 'package:flutter/material.dart';

class CardFilePendukung extends StatelessWidget {
  final List<String>? fotoPaths;
  final List<String>? tags;

  const CardFilePendukung({
    super.key,
    this.fotoPaths,
    this.tags,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final List<String> fotoList = fotoPaths?.isNotEmpty == true
        ? fotoPaths!
        : List.generate(
            12,
            (i) =>
                'https://dummyimage.com/100x100/cccccc/000000&text=Foto${i + 1}');

    final List<String> tagList = tags?.isNotEmpty == true
        ? tags!
        : ['Dokumen', 'Bukti Foto', 'Tambahan'];

    // Asumsikan: pembagian foto berdasarkan jumlah tag secara merata
    int groupSize = (fotoList.length / tagList.length).ceil();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'File Pendukung',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(tagList.length, (tagIndex) {
                  final start = tagIndex * groupSize;
                  final end = (start + groupSize > fotoList.length)
                      ? fotoList.length
                      : start + groupSize;
                  final List<String> groupFotos =
                      fotoList.sublist(start, end);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tagList[tagIndex],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: groupFotos.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (_, i) {
                            return Container(
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage(groupFotos[i]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
