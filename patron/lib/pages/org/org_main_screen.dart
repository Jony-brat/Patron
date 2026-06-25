import 'package:flutter/material.dart';
import 'org_home_page.dart';
import 'org_transfers_page.dart';
import 'org_settings_page.dart';
import 'org_support_page.dart';

class OrgMainScreen extends StatefulWidget {
  const OrgMainScreen({super.key});

  @override
  State<OrgMainScreen> createState() => _OrgMainScreenState();
}

class _OrgMainScreenState extends State<OrgMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const OrgHomePage(),
    const OrgTransfersPage(),
    const OrgSettingsPage(),
    const OrgSupportPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Patron', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Уведомлений пока нет')),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Переводы'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Настройки'),
          BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: 'Поддержка'),
        ],
      ),
    );
  }
}