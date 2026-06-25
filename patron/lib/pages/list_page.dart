import 'package:flutter/material.dart';
import 'package:patron/services/database_service.dart';
import 'package:patron/main.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Map<String, dynamic>> _organizations = [];
  List<Map<String, dynamic>> _filteredOrganizations = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'Все';

  final List<String> _categories = ['Все', 'Детские дома', 'Приюты для животных', 'Помощь пожилым', 'Медицина', 'Экология'];

  @override
  void initState() {
    super.initState();
    _loadOrganizations();
  }

  Future<void> _loadOrganizations() async {
    setState(() => _isLoading = true);
    try {
      _organizations = await DatabaseService.instance.getAllOrganizations();
      _filteredOrganizations = _organizations;
    } catch (e) {
      print('Ошибка: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _filterOrganizations() {
    setState(() {
      _filteredOrganizations = _organizations.where((org) {
        final matchesSearch = _searchQuery.isEmpty ||
            org['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            org['description'].toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == 'Все' || org['category'] == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _showDonationDialog(Map<String, dynamic> org) {
    double amount = 500;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text('Помочь "${org['name']}"'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Выберите сумму:'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [100, 500, 1000, 2000].map((a) => _buildAmountButton(a, amount, setStateDialog)).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Своя сумма',
                  prefixText: '₽ ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (value) {
                  final val = double.tryParse(value);
                  if (val != null) setStateDialog(() => amount = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Спасибо за пожертвование!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: Text('Пожертвовать ${amount.round()} ₽'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountButton(int value, double current, void Function(void Function()) setState) {
    final selected = current == value;
    return GestureDetector(
      onTap: () => setState(() => current = value.toDouble()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.deepPurple : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text('$value ₽', style: TextStyle(color: selected ? Colors.white : Colors.grey.shade800, fontWeight: selected ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: (value) {
              _searchQuery = value;
              _filterOrganizations();
            },
            decoration: InputDecoration(
              hintText: 'Поиск организаций...',
              prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        SizedBox(
          height: 45,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: _categories.map((cat) => _buildCategoryChip(cat)).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredOrganizations.isEmpty
                  ? const Center(child: Text('Ничего не найдено'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _filteredOrganizations.length,
                      itemBuilder: (context, index) => _buildOrganizationCard(_filteredOrganizations[index]),
                    ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 13)),
        selected: _selectedCategory == label,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = label;
            _filterOrganizations();
          });
        },
        selectedColor: Colors.deepPurple.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildOrganizationCard(Map<String, dynamic> org) {
    final color = [Colors.blue, Colors.orange, Colors.green, Colors.red, Colors.teal, Colors.brown][org['id'] % 6];
    
    return Container(
      width: double.infinity, // Растягиваем по ширине
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Верхняя часть - фиксированной высоты
          SizedBox(
            height: 70, // Фиксированная высота
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.business, size: 26, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          org['name'],
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          org['category'] ?? '',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Описание - фиксированной высоты
          SizedBox(
            height: 60, // Фиксированная высота
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                org['description'] ?? '',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.3),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          
          // Прогресс-бар
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: ((org['total_received'] ?? 0) / 100000).clamp(0, 1),
                    backgroundColor: Colors.grey.shade200,
                    color: color,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${org['total_received']?.round() ?? 0} ₽',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'из 100 000 ₽',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Кнопка - фиксированной высоты
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: 42, // Фиксированная высота
              child: ElevatedButton(
                onPressed: () => _showDonationDialog(org),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Пожертвовать',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}