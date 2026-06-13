import 'package:flutter/material.dart';

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
  String _selectedFontSize = 'Средний';
  double _monthlyDonationAmount = 500;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🔔 Уведомления'),
          _buildSwitchTile(
            icon: Icons.notifications_active,
            title: 'Push-уведомления',
            subtitle: 'Получать уведомления о важных событиях',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('💳 Платежи и профиль'),
          _buildSwitchTile(
            icon: Icons.payment,
            title: 'Сохранять способы оплаты',
            subtitle: 'Для быстрых пожертвований в один клик',
            value: _savePaymentMethods,
            onChanged: (value) {
              setState(() {
                _savePaymentMethods = value;
              });
            },
          ),
          _buildListTile(
            icon: Icons.autorenew,
            title: 'Регулярные пожертвования',
            subtitle: '${_monthlyDonationAmount.round()} ₽ в месяц',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showDonationSettingsDialog();
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('🎨 Отображение'),
          _buildSwitchTile(
            icon: Icons.dark_mode,
            title: 'Тёмная тема',
            subtitle: 'Удобно для глаз в темноте',
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          _buildListTile(
            icon: Icons.text_fields,
            title: 'Размер шрифта',
            subtitle: 'Текущий: $_selectedFontSize',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showFontSizeDialog();
            },
          ),
          _buildListTile(
            icon: Icons.language,
            title: 'Язык приложения',
            subtitle: 'Текущий: $_selectedLanguage',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('🔒 Конфиденциальность'),
          _buildSwitchTile(
            icon: Icons.visibility_off,
            title: 'Анонимные пожертвования',
            subtitle: 'Не показывать моё имя в отчётах',
            value: _anonymousDonations,
            onChanged: (value) {
              setState(() {
                _anonymousDonations = value;
              });
            },
          ),
          _buildListTile(
            icon: Icons.privacy_tip,
            title: 'Политика конфиденциальности',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showPrivacyPolicy();
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('🤝 Социальное'),
          _buildListTile(
            icon: Icons.share,
            title: 'Пригласить друзей',
            subtitle: 'Расскажите о Patron близким',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _shareApp();
            },
          ),
          _buildListTile(
            icon: Icons.emoji_events,
            title: 'Мои достижения',
            subtitle: 'Статистика ваших добрых дел',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showComingSoon();
            },
          ),
          const SizedBox(height: 24),
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
            icon: Icons.star,
            title: 'Оценить приложение',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _rateApp();
            },
          ),
          _buildListTile(
            icon: Icons.feedback,
            title: 'Отправить отзыв',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _sendFeedback();
            },
          ),
          _buildListTile(
            icon: Icons.delete_sweep,
            title: 'Очистить кэш',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showClearCacheDialog();
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
  
  void _showDonationSettingsDialog() {
    double amount = _monthlyDonationAmount;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Регулярные пожертвования'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Сумма ежемесячного пожертвования:'),
                  const SizedBox(height: 10),
                  Text(
                    '${amount.round()} ₽',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: amount,
                    min: 100,
                    max: 10000,
                    divisions: 99,
                    onChanged: (value) {
                      setStateDialog(() {
                        amount = value;
                      });
                      setState(() {
                        _monthlyDonationAmount = amount;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Настройки сохранены!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }
  
  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Размер шрифта'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Маленький', 'Средний', 'Большой', 'Очень большой'].map((size) {
              return RadioListTile(
                title: Text(size),
                value: size,
                groupValue: _selectedFontSize,
                onChanged: (value) {
                  setState(() {
                    _selectedFontSize = value.toString();
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
  
  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Политика конфиденциальности'),
          content: const SingleChildScrollView(
            child: Text(
              'Мы уважаем вашу конфиденциальность и защищаем персональные данные.\n\n'
              'Ваши данные используются только для обработки пожертвований и '
              'не передаются третьим лицам без вашего согласия.',
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
  
  void _shareApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Функция приглашения друзей появится позже')),
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
            Text('Благотворительное приложение для помощи нуждающимся'),
            SizedBox(height: 10),
            Text('© 2024 Patron. Все права защищены.'),
          ],
        );
      },
    );
  }
  
  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Спасибо за оценку!')),
    );
  }
  
  void _sendFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Форма обратной связи появится позже')),
    );
  }
  
  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Очистить кэш'),
          content: const Text('Вы уверены? Это освободит место на устройстве.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Кэш очищен')),
                );
              },
              child: const Text('Очистить', style: TextStyle(color: Colors.red)),
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