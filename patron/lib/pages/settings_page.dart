import 'package:flutter/material.dart';
import 'package:patron/main.dart';
import 'package:patron/pages/auth/auth_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _anonymousDonations = false;
  bool _savePaymentMethods = true;
  String _selectedLanguage = 'Русский';

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход из аккаунта'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              currentUserId = null;
              currentOrgId = null;
              isOrganizationMode = false;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
                (route) => false,
              );
            },
            child: const Text('Выйти', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🔔 Уведомления'),
          _buildSwitchTile(Icons.notifications_active, 'Push-уведомления', 'Получать уведомления о важных событиях', _notificationsEnabled, (v) => setState(() => _notificationsEnabled = v)),
          const SizedBox(height: 24),
          _buildSectionHeader('💳 Платежи и профиль'),
          _buildSwitchTile(Icons.payment, 'Сохранять способы оплаты', 'Для быстрых пожертвований', _savePaymentMethods, (v) => setState(() => _savePaymentMethods = v)),
          const SizedBox(height: 24),
          _buildSectionHeader('🎨 Отображение'),
          _buildSwitchTile(Icons.dark_mode, 'Тёмная тема', 'Удобно для глаз в темноте', _darkModeEnabled, (v) => setState(() => _darkModeEnabled = v)),
          _buildListTile(Icons.language, 'Язык приложения', 'Текущий: $_selectedLanguage', () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Выбор языка появится позже')),
            );
          }),
          const SizedBox(height: 24),
          _buildSectionHeader('🔒 Конфиденциальность'),
          _buildSwitchTile(Icons.visibility_off, 'Анонимные пожертвования', 'Не показывать моё имя в отчётах', _anonymousDonations, (v) => setState(() => _anonymousDonations = v)),
          const SizedBox(height: 24),
          _buildSectionHeader('ℹ️ О приложении'),
          _buildListTile(Icons.info, 'О Patron', 'Версия 1.0.0', () {
            showDialog(
              context: context,
              builder: (context) => AboutDialog(
                applicationName: 'Patron',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.favorite, color: Colors.deepPurple, size: 40),
                children: const [Text('Благотворительное приложение'), SizedBox(height: 10), Text('© 2024 Patron')],
              ),
            );
          }),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          _buildSectionHeader('🚪 Аккаунт'),
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Выйти из аккаунта', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              subtitle: const Text('Завершить сеанс работы'),
              trailing: const Icon(Icons.chevron_right, color: Colors.red),
              onTap: _logout,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, String subtitle, bool value, Function(bool) onChanged) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        secondary: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.deepPurple,
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}