import 'package:flutter/material.dart';
import 'package:report_school/pages/login_page.dart';
import './theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/pengumuman_provider.dart';
import 'providers/progres_provider.dart';
import '../providers/file_pendukung_provider.dart';
import 'controller/tag_foto_controller.dart';
import 'providers/get_laporan_detail_provider.dart';
import 'providers/laporan_provider.dart';
import 'providers/auth_provider.dart';
import 'controller/progress_controller.dart';
import 'controller/laporan_controller.dart';
import 'providers/get_progres_detail_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PengumumanProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => TagFotoController()),
        ChangeNotifierProvider(create: (_) => GetDetailLaporanProvider()),

        // Provider untuk GetDetailProgresProvider
        ChangeNotifierProvider(create: (_) => GetDetailProgresProvider()),

        // Provider untuk AuthProvider
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Provider untuk LaporanProvider
        ChangeNotifierProvider(create: (_) => LaporanProvider()),

        // Provider untuk LaporanController
        ChangeNotifierProvider(create: (_) => LaporanController()),

        // Provider untuk ProgressController
        ChangeNotifierProvider(create: (_) => ProgressController()),


        // Provider untuk FilePendukungProvider
        ChangeNotifierProvider(create: (_) => FilePendukungProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report School',
      theme: AppTheme.lightTheme,
      home: LoginPage(),
    );
  }
}
