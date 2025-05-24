import 'package:flutter/material.dart';

class SystemMessageCard extends StatelessWidget {
  final String message;
  final String yesText;
  final String noText;

  const SystemMessageCard({
    super.key,
    this.message = 'Apakah kamu yakin',
    this.yesText = 'Ya, lanjutkan',
    this.noText = 'Tidak, batalkan',
  });

  @override
  Widget build(BuildContext context) {
    // Ukuran window yang diinginkan
    const double windowWidth = 200.0;
    const double minWindowHeight = 200.0;

    return SizedBox(
      width: windowWidth,
      child: Card(
        elevation: 5.0, // Memberikan efek bayangan pada Card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Membuat sudut Card melengkung
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: minWindowHeight, // Tinggi minimal Card
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Membuat Column menyesuaikan tinggi konten
            crossAxisAlignment: CrossAxisAlignment.stretch, // Membuat children Column selebar Card
            children: <Widget>[
              // Header "Pesan Sistem"
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: const BoxDecoration(
                  color: Colors.blue, // Warna biru seperti di gambar
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: const Text(
                  'Pesan Sistem',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),

              // Konten Pesan (bisa custom)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              // Baris untuk Tombol
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          return Navigator.pop(context, true); // Mengembalikan nilai true saat tombol ditekan
                        },
                        child: Text(
                          yesText,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          return Navigator.pop(context, false); // Mengembalikan nilai false saat tombol ditekan
                        },
                        child: Text(
                          noText,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}