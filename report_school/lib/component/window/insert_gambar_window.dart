import 'package:flutter/material.dart';
import '../../component/window/konfirmasi_window.dart';

class UploadDokumenWindow extends StatelessWidget {
  const UploadDokumenWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: const Center(
                child: Text(
                  'Dokumen Pendukung',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.insert_drive_file, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Upload foto pendukung'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: null,
                ), // Ganti sesuai kebutuhan
                const Text("Tag foto 1"),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "Tambahkan tag baru",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tampilkan dialog konfirmasi
                _tampilkanDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 32,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _tampilkanDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent, // biar cardnya terlihat clean
        child: SystemMessageCard(
          message: "Apakah Anda yakin ingin mengunggah dokumen ini?",
          yesText: "Ya",
          noText: "Batal",
        ),
      );
    },
  );

  if (result == true) {
    // Lakukan aksi jika menekan "Ya"
    // Tutup dialog dan lakukan aksi yang diinginkan
  } else {
    // Tidak melakukan apa-apa jika batal
    // Dialog sudah tertutup secara otomatis
  }
 
  }

}

