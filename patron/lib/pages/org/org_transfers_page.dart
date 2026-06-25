import 'package:flutter/material.dart';
import 'package:patron/main.dart';
import 'package:patron/services/database_service.dart';

class OrgTransfersPage extends StatefulWidget {
  const OrgTransfersPage({super.key});

  @override
  State<OrgTransfersPage> createState() => _OrgTransfersPageState();
}

class _OrgTransfersPageState extends State<OrgTransfersPage> {
  String _filterType = 'Все';
  List<Map<String, dynamic>> _transfers = [];
  bool _isLoading = true;
  double _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadTransfers();
  }

  Future<void> _loadTransfers() async {
    if (currentOrgId == null) {
      setState(() => _isLoading = false);
      return;
    }
    
    setState(() => _isLoading = true);
    try {
      _transfers = await DatabaseService.instance.getDonationsForOrganization(currentOrgId!);
      _totalAmount = _transfers.fold(0, (sum, item) => sum + (item['amount'] as num).toDouble());
    } catch (e) {
      print('Ошибка загрузки переводов: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Map<String, dynamic>> get _filteredTransfers {
    if (_filterType == 'Все') {
      return _transfers;
    } else if (_filterType == 'С комментариями') {
      return _transfers.where((t) => 
        t['comment'] != null && t['comment'].toString().isNotEmpty
      ).toList();
    } else if (_filterType == 'Анонимные') {
      return _transfers.where((t) => t['is_anonymous'] == true).toList();
    }
    return _transfers;
  }

  String _truncateName(String name) {
    if (name.length > 25) {
      return name.substring(0, 22) + '...';
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Загрузка переводов...'),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Статистика
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6B2D8F), Color(0xFF9C27B0)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard('${_transfers.length}', 'Всего переводов'),
              _buildStatCard('${_totalAmount.round()} ₽', 'Общая сумма'),
              _buildStatCard(
                '${_transfers.where((t) => t['is_anonymous'] == true).length}', 
                'Анонимных'
              ),
            ],
          ),
        ),
        
        // Фильтры
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                'Фильтр:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SegmentedButton<String>(
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: Colors.deepPurple,
                    selectedForegroundColor: Colors.white,
                  ),
                  segments: const [
                    ButtonSegment(
                      value: 'Все', 
                      label: Text('Все', style: TextStyle(fontSize: 12)),
                    ),
                    ButtonSegment(
                      value: 'С комментариями', 
                      label: Text('С комм.', style: TextStyle(fontSize: 12)),
                    ),
                    ButtonSegment(
                      value: 'Анонимные', 
                      label: Text('Анонимные', style: TextStyle(fontSize: 12)),
                    ),
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
                      Icon(
                        Icons.wallet, 
                        size: 64, 
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Переводов пока нет',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _filteredTransfers.length,
                  itemBuilder: (context, index) {
                    return _buildTransferCard(_filteredTransfers[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.8),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildTransferCard(Map<String, dynamic> transfer) {
    // Проверяем анонимность
    final isAnonymous = transfer['is_anonymous'] == true;
    
    // Формируем имя пользователя
    String displayName = isAnonymous 
        ? 'Анонимный пользователь' 
        : (transfer['user_name'] ?? 'Пользователь');
    
    // Обрезаем длинные имена
    if (!isAnonymous && displayName.length > 25) {
      displayName = _truncateName(displayName);
    }
    
    // Формируем аватар
    String avatar = isAnonymous 
        ? '?' 
        : (displayName.isNotEmpty ? displayName[0].toUpperCase() : 'П');
    
    // Цвет аватара
    Color avatarColor = isAnonymous 
        ? Colors.grey 
        : Colors.deepPurple.shade300;
    
    // Форматируем дату
    String date = transfer['created_at']?.toString() ?? '';
    if (date.length > 16) {
      date = date.substring(0, 16).replaceAll('-', '.');
    }

    return Container(
      width: double.infinity,
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
                backgroundColor: avatarColor,
                child: Text(
                  avatar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
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
                        if (isAnonymous) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6, 
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Аноним',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              
              // Сумма
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+ ${transfer['amount']?.round() ?? 0} ₽',
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
          if (transfer['comment'] != null && 
              transfer['comment'].toString().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.format_quote,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      transfer['comment'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.3,
                      ),
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