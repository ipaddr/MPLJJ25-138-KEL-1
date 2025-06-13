import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CardFilePendukung extends StatelessWidget {
  final List<String> fotoPaths;
  final List<String> tags;

  const CardFilePendukung({
    super.key,
    required this.fotoPaths,
    required this.tags,
  });

  static const String serverIp = "192.168.130.167"; // <- Ganti sesuai IP-mu
  static const String port = "8000";

  String buildImageUrl(String path) {
    if (path.startsWith("http")) return path;
    final cleanedPath = path.replaceFirst("public/", "");
    return "http://$serverIp:$port/storage/$cleanedPath";
  }

  Future<bool> checkImageExists(String url) async {
    for (int attempt = 1; attempt <= 10; attempt++) {
      try {
        final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
        if (response.statusCode == 200) {
          return true;
        } else {
          debugPrint("Percobaan $attempt gagal: Status ${response.statusCode}");
        }
      } catch (e) {
        debugPrint("Percobaan $attempt error: $e");
      }

      // Tunggu sebentar sebelum retry
      await Future.delayed(const Duration(seconds: 2));
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (fotoPaths.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Tidak ada file pendukung."),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(fotoPaths.length, (index) {
        final fotoUrl = buildImageUrl(fotoPaths[index]);
        final tag = (index < tags.length) ? tags[index] : "-";

        return FutureBuilder<bool>(
          future: checkImageExists(fotoUrl),
          builder: (context, snapshot) {
            Widget imageWidget;

            if (snapshot.connectionState == ConnectionState.waiting) {
              imageWidget = const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData && snapshot.data == true) {
              imageWidget = Image.network(
                fotoUrl,
                height: 180,
                fit: BoxFit.cover,
              );
            } else {
              imageWidget = const SizedBox(
                height: 180,
                child: Center(child: Icon(Icons.broken_image, size: 40)),
              );
            }

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: imageWidget,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Tag: $tag"),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
