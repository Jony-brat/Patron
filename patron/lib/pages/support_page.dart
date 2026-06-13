import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Кто мы такие?'),
          const Text(
            'Каждый день рядом с нами есть люди, которые сталкиваются с трудностями: дети без семьи, пожилые в одиночестве, семьи в сложной жизненной ситуации, бездомные животные и те, кто борется с тяжёлыми заболеваниями.\n\n'
            'Patron — это благотворительная организация, которая уже [X лет] помогает тем, кому особенно нужна поддержка. Мы верим, что даже маленький вклад может изменить чью‑то жизнь к лучшему.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Как вы можете помочь?'),
          const Text(
            'Ваша поддержка — это реальная помощь тем, кто в ней нуждается. Вы можете внести свой вклад несколькими способами:',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 12),
          _buildHelpCard('💝 Единоразовое пожертвование', 'Переведите любую сумму, которая будет направлена на текущие нужды подопечных Patron.'),
          _buildHelpCard('🔄 Регулярная поддержка (автоплатеж)', 'Подключите ежемесячное пожертвование — так мы сможем планировать помощь на долгосрочную перспективу.'),
          _buildHelpCard('🙋 Волонтёрство', 'Уделите своё время и навыки: помогайте в организации мероприятий, участвуйте в акциях.'),
          _buildHelpCard('📦 Материальная помощь', 'Предоставьте вещи первой необходимости, продукты, медикаменты.'),
          _buildHelpCard('📢 Распространение информации', 'Расскажите о работе Patron своим друзьям, коллегам и подписчикам.'),
          _buildHelpCard('🏢 Корпоративное партнёрство', 'Компании могут поддержать нас через благотворительные программы.'),
          const SizedBox(height: 24),
          _buildSectionTitle('На что идут пожертвования?'),
          const Text(
            'Мы работаем прозрачно и ответственно. Ваши средства направляются на:',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 12),
          _buildBulletPoint('помощь детям‑сиротам и детям с особенностями развития'),
          _buildBulletPoint('поддержку пожилых людей и инвалидов'),
          _buildBulletPoint('программы помощи бездомным'),
          _buildBulletPoint('лечение и реабилитацию тяжелобольных'),
          _buildBulletPoint('помощь приютам для животных'),
          _buildBulletPoint('организацию благотворительных акций и мероприятий'),
          const SizedBox(height: 16),
          const Text(
            'Каждый рубль имеет значение. Даже небольшая сумма может оплатить лекарства, питание, обучение или просто подарить улыбку тому, кто в этом особенно нуждается.',
            style: TextStyle(fontSize: 16, height: 1.5, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Почему стоит поддержать Patron?'),
          _buildBulletPoint('Прозрачность. Мы публикуем отчёты о расходовании средств.'),
          _buildBulletPoint('Эффективность. Наши программы приносят ощутимую пользу.'),
          _buildBulletPoint('Доверие. Нас поддерживают тысячи людей и организаций.'),
          _buildBulletPoint('Человечность. Мы даём надежду и веру в лучшее.'),
          const SizedBox(height: 24),
          _buildSectionTitle('Как сделать пожертвование?'),
          const Text(
            '1. Выберите способ поддержки выше.\n'
            '2. Перейдите в раздел «Пожертвовать».\n'
            '3. Укажите сумму и способ оплаты.\n'
            '4. Подтвердите перевод — и ваше доброе дело совершится!\n',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('Свяжитесь с нами'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContactRow(Icons.phone, 'Телефон: [+7 (XXX) XXX-XX-XX]'),
                const SizedBox(height: 8),
                _buildContactRow(Icons.email, 'Email: [info@patron.org]'),
                const SizedBox(height: 8),
                _buildContactRow(Icons.share, 'Соцсети: [ссылки на профили]'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Text(
                  'Спасибо, что вы с нами!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'Вместе мы можем сделать мир добрее и светлее. Ваше участие — это не просто помощь, это надежда для тех, кто в ней так нуждается.',
                  style: TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Patron: добро начинается с тебя.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
  
  Widget _buildHelpCard(String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 14, height: 1.4)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16, height: 1.4))),
        ],
      ),
    );
  }
  
  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.deepPurple),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}