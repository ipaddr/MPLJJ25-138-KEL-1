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
    final List<String> fotoList = fotoPaths?.isNotEmpty == true
        ? fotoPaths!
        : [
            'https://dummyimage.com/100x100/cccccc/000000&text=Foto',
            'https://dummyimage.com/100x100/cccccc/000000&text=Foto',
            'https://dummyimage.com/100x100/cccccc/000000&text=Foto',
          ];

    final List<String> tagList = tags?.isNotEmpty == true
        ? tags!
        : ['Dokumen', 'Bukti Foto', 'Tambahan'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'File Pendukung',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Foto-foto
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: fotoList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(fotoList[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tags
                    Wrap(
                      spacing: 8,
                      children: tagList.map((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor: Colors.blue.shade100,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
