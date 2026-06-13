import 'package:flutter/material.dart';

class OrgSettingsPage extends StatefulWidget {
  const OrgSettingsPage({super.key});

  @override
  State<OrgSettingsPage> createState() => _OrgSettingsPageState();
}

class _OrgSettingsPageState extends State<OrgSettingsPage> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _showInSearch = true;
  String _selectedCurrency = 'RUB';
  String _selectedLanguage = 'Русский';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Уведомления
          _buildSectionHeader('🔔 Уведомления'),
          _buildSwitchTile(
            icon: Icons.email,
            title: 'Email уведомления',
            subtitle: 'Получать уведомления о новых пожертвованиях на email',
            value: _emailNotifications,
            onChanged: (value) {
              setState(() {
                _emailNotifications = value;
              });
            },
          ),
          _buildSwitchTile(
            icon: Icons.notifications_active,
            title: 'Push-уведомления',
            subtitle: 'Получать уведомления в приложении',
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          // Настройки профиля
          _buildSectionHeader('🏢 Настройки профиля'),
          _buildSwitchTile(
            icon: Icons.search,
            title: 'Показывать организацию в поиске',
            subtitle: 'Вашу организацию смогут найти пользователи',
            value: _showInSearch,
            onChanged: (value) {
              setState(() {
                _showInSearch = value;
              });
            },
          ),
          
          _buildListTile(
            icon: Icons.attach_money,
            title: 'Валюта',
            subtitle: 'Текущая: $_selectedCurrency',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showCurrencyDialog();
            },
          ),
          
          _buildListTile(
            icon: Icons.language,
            title: 'Язык интерфейса',
            subtitle: 'Текущий: $_selectedLanguage',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          
          const SizedBox(height: 24),
          
          // Интеграции
          _buildSectionHeader('🔗 Интеграции'),
          _buildListTile(
            icon: Icons.link,
            title: 'Подключить соцсети',
            subtitle: 'Поделиться постами в соцсетях',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showComingSoon();
            },
          ),
          
          _buildListTile(
            icon: Icons.widgets,
            title: 'Виджет для сайта',
            subtitle: 'Разместить форму пожертвования на вашем сайте',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showComingSoon();
            },
          ),
          
          const SizedBox(height: 24),
          
          // Отчеты
          _buildSectionHeader('📊 Отчеты'),
          _buildListTile(
            icon: Icons.download,
            title: 'Скачать отчет по пожертвованиям',
            subtitle: 'Экспорт в Excel/PDF',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showReportDialog();
            },
          ),
          
          const SizedBox(height: 24),
          
          // О приложении
          _buildSectionHeader('ℹ️ О приложении'),
          _buildListTile(
            icon: Icons.info,
            title: 'О Patron',
            subtitle: 'Версия 1.0.0',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showAboutDialog();
            },
          ),
          
          _buildListTile(
            icon: Icons.description,
            title: 'Пользовательское соглашение',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showTermsDialog();
            },
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
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

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите валюту'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['RUB', 'USD', 'EUR'].map((currency) {
              return RadioListTile(
                title: Text(currency),
                value: currency,
                groupValue: _selectedCurrency,
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value.toString();
                  });
                  Navigator.pop(context);
                },
                activeColor: Colors.deepPurple,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите язык'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Русский', 'English'].map((language) {
              return RadioListTile(
                title: Text(language),
                value: language,
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value.toString();
                  });
                  Navigator.pop(context);
                },
                activeColor: Colors.deepPurple,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите период'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('За последний месяц'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Отчет формируется...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_view_month),
                title: const Text('За последний год'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Отчет формируется...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text('Выбрать свой период'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Выбор периода появится позже')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AboutDialog(
          applicationName: 'Patron',
          applicationVersion: '1.0.0',
          applicationIcon: const Icon(Icons.favorite, color: Colors.deepPurple, size: 40),
          children: const [
            Text('Платформа для благотворительных организаций'),
            SizedBox(height: 10),
            Text('© 2024 Patron. Все права защищены.'),
          ],
        );
      },
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Пользовательское соглашение'),
          content: const SingleChildScrollView(
            child: Text(
              '1. Организация обязуется предоставлять достоверную информацию о своей деятельности.\n\n'
              '2. Все собранные средства должны использоваться строго по назначению.\n\n'
              '3. Организация обязуется предоставлять отчеты о расходовании средств.\n\n'
              '4. Patron имеет право проверить деятельность организации.\n\n'
              '5. При нарушении правил аккаунт организации может быть заблокирован.',
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

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Функция скоро появится!')),
    );
  }
}