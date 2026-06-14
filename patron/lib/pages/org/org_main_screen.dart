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
  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Patron',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              _showNotificationsDialog();
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: const IconThemeData(size: 28),
        unselectedIconTheme: const IconThemeData(size: 24),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Переводы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Поддержка',
          ),
        ],
      ),
    );
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Уведомления'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.favorite, color: Colors.white, size: 16),
                  ),
                  title: const Text('Новое пожертвование!'),
                  subtitle: const Text('Аноним пожертвовал 500 ₽'),
                  trailing: Text('5 мин назад', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white, size: 16),
                  ),
                  title: const Text('Новый подписчик'),
                  subtitle: const Text('Иван Иванов подписался на обновления'),
                  trailing: Text('2 часа назад', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.thumb_up, color: Colors.white, size: 16),
                  ),
                  title: const Text('Ваш пост получил 10 лайков!'),
                  subtitle: const Text('Пост о сборе средств'),
                  trailing: Text('Вчера', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}