import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../component/card_view/card_laporan.dart';

class ListLaporanPage extends StatefulWidget {
  const ListLaporanPage({super.key});

  @override
  State createState() => _ListLaporanPageState();
}

class _ListLaporanPageState extends State<ListLaporanPage> {
  bool _isLoading = true;
  bool _isTimeout = false;

  int get _timeoutDuration => 2; // Durasi timeout dalam detik

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      try {
        // Fetch laporan diterima
        // ignore: use_build_context_synchronously
        final homeProvider = Provider.of<HomeProvider>(context, listen: false);

        await Future.wait([
          homeProvider.fetchLaporanDiterima(),
          homeProvider.checkIsAdmin(),
        ]).timeout(
          Duration(seconds: _timeoutDuration),
          onTimeout: () {
            setState(() {
              _isTimeout = true;
              _isLoading = false;
            });
            return []; // return kosong biar tidak crash
          },
        );

        if (mounted && !_isTimeout) {
          setState(() => _isLoading = false);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isTimeout = true;
            _isLoading = false;
          });
        }
      }
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _isTimeout = false;
    });

    try {
      await Future.wait([
        context.read<HomeProvider>().fetchLaporanDiterima(),
        context.read<HomeProvider>().checkIsAdmin(),
      ]).timeout(Duration(seconds: _timeoutDuration));

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isTimeout = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isTimeout = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final laporanListDiterima = context.watch<HomeProvider>().laporanListDiterima;

    return Scaffold(
      appBar: AppBar(title: const Text('List Laporan')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isTimeout
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning_amber, size: 64, color: Colors.orange),
                      const SizedBox(height: 16),
                      const Text(
                        'Tidak ada respons dari server.\nSilakan coba lagi.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshData,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  child: laporanListDiterima.isEmpty
                      ? ListView(
                          children: [
                            const SizedBox(height: 100),
                            Center(
                              child: Text(
                                'Belum ada laporan yang diterima oleh Admin.',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      : Padding(
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
                                itemCount: laporanListDiterima.length,
                                itemBuilder: (context, index) {
                                  return CardLaporan(laporan: laporanListDiterima[index]);
                                },
                              ),
                            ],
                          ),
                        ),
                ),
    );
  }
}
