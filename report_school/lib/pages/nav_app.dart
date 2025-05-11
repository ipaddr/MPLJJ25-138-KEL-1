import 'package:flutter/material.dart';
import 'home_page.dart';
import 'list_laporan.dart';
import '../component/nav/bottom_navigation.dart';

class NavApp extends StatefulWidget {
  const NavApp({super.key}); // Pastikan constructor sama dengan nama class

  @override
  State<NavApp> createState() => _NavAppState(); // Sesuaikan nama state class
}

class _NavAppState extends State<NavApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ListLaporanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
