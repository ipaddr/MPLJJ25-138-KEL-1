import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/progres_provider.dart';
import '../component/card_view/card_progres.dart';

class ListProgresPage extends StatefulWidget {
  const ListProgresPage({super.key});

  @override
  State<ListProgresPage> createState() => _ListProgresPageState();
}

class _ListProgresPageState extends State<ListProgresPage> {
  @override
  void initState() {
    super.initState();
    // Load data dummy saat pertama kali dibuka
    final provider = Provider.of<ProgressProvider>(context, listen: false);
    provider.loadDummyData();
  }

  @override
  Widget build(BuildContext context) {
    final progressList = context.watch<ProgressProvider>().progressList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Progress'),
        backgroundColor: AppTheme.blueCard,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Progress Sedang Berjalan',
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
              itemCount: progressList.length,
              itemBuilder: (context, index) {
                return CardProgress(progres: progressList[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
