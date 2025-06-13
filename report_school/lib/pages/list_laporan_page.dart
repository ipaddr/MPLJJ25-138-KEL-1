import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../component/card_view/card_laporan_home.dart';

class ListLaporanPage extends StatefulWidget {
  const ListLaporanPage({super.key});

  @override
  State createState() => _ListLaporanPageState();
}

class _ListLaporanPageState extends State<ListLaporanPage> {

  @override
  Widget build(BuildContext context) {
    final laporanList = context.watch<HomeProvider>().laporanList;

    return Scaffold(
      appBar: AppBar(title: const Text('List Laporan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Laporan Diterima',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 1,
              color: Theme.of(context).colorScheme.onSurface,
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: laporanList.length,
              itemBuilder: (context, index) {
                return CardLaporanHome(laporan: laporanList[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
