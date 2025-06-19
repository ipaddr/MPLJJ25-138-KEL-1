import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../component/card_view/card_progres.dart';
import '../providers/progres_provider.dart';
import '../providers/auth_provider.dart';

class ListProgressPage extends StatefulWidget {
  const ListProgressPage({super.key});

  @override
  State createState() => _ListProgressPageState();
}

class _ListProgressPageState extends State<ListProgressPage> {
  bool _isLoading = true;
  bool _isTimeout = false;

  int get _timeoutDuration => 2;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      try {
        setState(() {
          _isLoading = true;
          _isTimeout = false;
        });

        // Ambil data progress dan cek admin
        // ignore: use_build_context_synchronously
        final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
        // ignore: use_build_context_synchronously
        final checkAdmin = Provider.of<AuthProvider>(context, listen: false);

        // Ubah ini jika nanti ada fetch asli dari API
        await progressProvider.fetchProgress();

        await checkAdmin.checkIsAdmin().timeout(
          Duration(seconds: _timeoutDuration),
          onTimeout: () {
            setState(() {
              _isTimeout = true;
              _isLoading = false;
            });
            return;
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
      final authProvider = context.read<AuthProvider>();
      final progressProvider = context.read<ProgressProvider>();

      // Provider
      await authProvider.checkIsAdmin().timeout(Duration(seconds: _timeoutDuration));      
      await Future.wait([
        authProvider.checkIsAdmin().timeout(Duration(seconds: _timeoutDuration)),
        progressProvider.fetchProgress(),
        progressProvider.fetchProgressSelesai(),
      ]);

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
    final progressList = context.watch<ProgressProvider>().progressList;
    final progressListSelesai = context.watch<ProgressProvider>().progressListSelesai;

    return Scaffold(
      appBar: AppBar(title: const Text('List Progress')),
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
                  child: progressList.isEmpty
                      ? ListView(
                          children: [
                            const SizedBox(height: 100),
                            Center(
                              child: Text(
                                'Belum ada progress yang diterima.',
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
                                'Progress Berjalan',
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

                              const SizedBox(height: 8),

                              if (progressListSelesai.isNotEmpty)...[
                                Text(
                                  'Progress Selesai',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                ),

                                Container(
                                  height: 1,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                ),

                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: progressListSelesai.length,
                                  itemBuilder: (context, index) {
                                    return CardProgress(progres: progressListSelesai[index]);
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                ),
    );
  }
}
