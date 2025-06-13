import 'package:flutter/material.dart';
import 'package:report_school/pages/login_page.dart';
import './theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
// ignore: unused_import
import 'pages/nav_app.dart';
import 'providers/home_provider.dart';
import 'providers/pengumuman_provider.dart';
import 'providers/progres_provider.dart';
import './controller/sekolah_controller.dart';
import '../providers/file_pendukung_provider.dart';
import 'controller/tag_foto_controller.dart';
import 'providers/get_detail_laporan_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => PengumumanProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => TagFotoController()),
        ChangeNotifierProvider(create: (_) => GetDetailLaporanProvider()),
        ChangeNotifierProvider(
          create: (_) => SekolahController(),
        ),
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
