import 'package:flutter/material.dart';

class OrgTransfersPage extends StatefulWidget {
  const OrgTransfersPage({super.key});

  @override
  State<OrgTransfersPage> createState() => _OrgTransfersPageState();
}

class _OrgTransfersPageState extends State<OrgTransfersPage> {
  String _filterType = 'Все';
  
  // Список переводов
  List<Map<String, dynamic>> _transfers = [
    {
      'id': '1',
      'amount': 5000,
      'date': '15.06.2024',
      'time': '14:30',
      'userName': 'Анна Смирнова',
      'isAnonymous': false,
      'comment': 'На добрые дела! Спасибо за вашу работу 🙏',
      'avatar': 'А',
      'color': Colors.blue,
    },
    {
      'id': '2',
      'amount': 1200,
      'date': '14.06.2024',
      'time': '09:15',
      'userName': 'Анонимный пользователь',
      'isAnonymous': true,
      'comment': 'Пусть у детей будет счастливое детство',
      'avatar': '?',
      'color': Colors.grey,
    },
    {
      'id': '3',
      'amount': 30000,
      'date': '13.06.2024',
      'time': '18:45',
      'userName': 'Михаил Петрович Иванов',
      'isAnonymous': false,
      'comment': 'Для ремонта игровой комнаты',
      'avatar': 'М',
      'color': Colors.green,
    },
    {
      'id': '4',
      'amount': 750,
      'date': '12.06.2024',
      'time': '11:20',
      'userName': 'Анонимный пользователь',
      'isAnonymous': true,
      'comment': 'Добра вам!',
      'avatar': '?',
      'color': Colors.grey,
    },
    {
      'id': '5',
      'amount': 15000,
      'date': '11.06.2024',
      'time': '16:00',
      'userName': 'Елена Александровна Васильева',
      'isAnonymous': false,
      'comment': 'Пожалуйста, купите детям игрушки',
      'avatar': 'Е',
      'color': Colors.orange,
    },
  ];

  // Функция для обрезки длинных имен
  String _truncateName(String name) {
    if (name.length > 25) {
      return name.substring(0, 22) + '...';
    }
    return name;
  }

  List<Map<String, dynamic>> get _filteredTransfers {
    if (_filterType == 'Все') {
      return _transfers;
    } else if (_filterType == 'С комментариями') {
      return _transfers.where((t) => t['comment'].isNotEmpty).toList();
    } else if (_filterType == 'Анонимные') {
      return _transfers.where((t) => t['isAnonymous'] == true).toList();
    } else {
      return _transfers;
    }
  }

  double get _totalAmount {
    return _filteredTransfers.fold(0, (sum, item) => sum + (item['amount'] as int));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Статистика
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard('${_transfers.length}', 'Всего переводов'),
              _buildStatCard('${_totalAmount} ₽', 'Общая сумма'),
              _buildStatCard('${_transfers.where((t) => t['isAnonymous'] == true).length}', 'Анонимных'),
            ],
          ),
        ),
        
        // Фильтры
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text('Фильтр:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(width: 12),
              Expanded(
                child: SegmentedButton<String>(
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: Colors.deepPurple,
                    selectedForegroundColor: Colors.white,
                  ),
                  segments: const [
                    ButtonSegment(value: 'Все', label: Text('Все', style: TextStyle(fontSize: 12))),
                    ButtonSegment(value: 'С комментариями', label: Text('С комм.', style: TextStyle(fontSize: 12))),
                    ButtonSegment(value: 'Анонимные', label: Text('Анонимные', style: TextStyle(fontSize: 12))),
                  ],
                  selected: {_filterType},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _filterType = newSelection.first;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Список переводов
        Expanded(
          child: _filteredTransfers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wallet, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Переводов пока нет',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredTransfers.length,
                  itemBuilder: (context, index) {
                    final transfer = _filteredTransfers[index];
                    return _buildTransferCard(transfer);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildTransferCard(Map<String, dynamic> transfer) {
    // Обрезаем длинное имя (если больше 25 символов)
    String displayName = transfer['userName'];
    if (!transfer['isAnonymous'] && displayName.length > 25) {
      displayName = displayName.substring(0, 22) + '...';
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Аватар
              CircleAvatar(
                radius: 20,
                backgroundColor: transfer['color'],
                child: Text(
                  transfer['avatar'],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(width: 12),
              
              // Информация о пользователе
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        if (transfer['isAnonymous'])
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Аноним',
                              style: TextStyle(fontSize: 9, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${transfer['date']} в ${transfer['time']}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              
              // Сумма
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+ ${transfer['amount']} ₽',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          
          // Комментарий (если есть)
          if (transfer['comment'].isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.format_quote, size: 14, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      transfer['comment'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.3),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}