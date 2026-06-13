import 'package:flutter/material.dart';

class OrgSupportPage extends StatefulWidget {
  const OrgSupportPage({super.key});

  @override
  State<OrgSupportPage> createState() => _OrgSupportPageState();
}

class _OrgSupportPageState extends State<OrgSupportPage> {
  final _messageController = TextEditingController();
  final _subjectController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  void _sendMessage() {
    if (_subjectController.text.isNotEmpty && _messageController.text.isNotEmpty) {
      setState(() {
        _messages.insert(0, {
          'subject': _subjectController.text,
          'message': _messageController.text,
          'date': DateTime.now().toString().substring(0, 16),
          'isUser': true,
        });
      });
      _subjectController.clear();
      _messageController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сообщение отправлено! Ответ придет на email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Контакты поддержки
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(Icons.headset_mic, size: 50, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'Служба поддержки',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Мы готовы помочь вам 24/7',
                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildContactButton(Icons.phone, 'Звонок', () {
                      _showComingSoon();
                    }),
                    _buildContactButton(Icons.email, 'Email', () {
                      _showComingSoon();
                    }),
                    _buildContactButton(Icons.telegram, 'Telegram', () {
                      _showComingSoon();
                    }),
                  ],
                ),
              ],
            ),
          ),
          
          // Часто задаваемые вопросы
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              '❓ Часто задаваемые вопросы',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          
          const SizedBox(height: 8),
          
          _buildFaqCard(
            question: 'Как получить выплату?',
            answer: 'Выплаты производятся автоматически каждый месяц при достижении минимальной суммы 1000 ₽. Средства поступают на указанный при регистрации счет.',
          ),
          _buildFaqCard(
            question: 'Как изменить данные организации?',
            answer: 'Перейдите в раздел "Главная" → нажмите на кнопку редактирования в карточке организации. Там вы сможете изменить всю информацию.',
          ),
          _buildFaqCard(
            question: 'Как создать пост?',
            answer: 'На главной странице нажмите кнопку "Создать пост". Заполните заголовок, содержание и выберите иконку. Пост сразу появится в ленте.',
          ),
          _buildFaqCard(
            question: 'Где я могу посмотреть отчет?',
            answer: 'В разделе "Настройки" → "Отчеты" вы можете скачать полный отчет по всем пожертвованиям в формате Excel или PDF.',
          ),
          
          const SizedBox(height: 16),
          
          // Написать в поддержку
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              '💬 Написать в поддержку',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    labelText: 'Тема обращения',
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Сообщение',
                    prefixIcon: const Icon(Icons.message),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  label: const Text('Отправить сообщение'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // История обращений
          if (_messages.isNotEmpty) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                '📝 История обращений',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ..._messages.map((msg) => _buildMessageCard(msg)),
          ],
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildContactButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onTap,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.2),
          ),
        ),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)),
      ],
    );
  }

  Widget _buildFaqCard({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: const Icon(Icons.help_outline, color: Colors.deepPurple),
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: message['isUser'] ? Colors.deepPurple.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: message['isUser'] ? Colors.deepPurple.shade200 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                message['isUser'] ? Icons.person : Icons.support_agent,
                size: 20,
                color: message['isUser'] ? Colors.deepPurple : Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message['subject'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                message['date'],
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(message['message'], style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Функция скоро появится!')),
    );
  }
}