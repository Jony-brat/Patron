import 'package:flutter/material.dart';
import 'package:patron/main.dart';

class Organization {
  final String name;
  final String description;
  final String goal;
  final double raised;
  final double target;
  final Color color;
  final IconData icon;
  final List<String> images;

  Organization({
    required this.name,
    required this.description,
    required this.goal,
    required this.raised,
    required this.target,
    required this.color,
    required this.icon,
    required this.images,
  });

  double get percentage => (raised / target) * 100;
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late List<Organization> organizations;
  String _searchQuery = '';
  String _selectedCategory = 'Все';

  @override
  void initState() {
    super.initState();
    _initOrganizations();
  }

  void _initOrganizations() {
    organizations = [
      Organization(
        name: 'Детский дом "Надежда"',
        description: 'Помогаем детям-сиротам найти семью и получить достойное образование. Средства идут на ремонт помещений, покупку игрушек, книг и организацию праздников.',
        goal: 'Сбор на ремонт и игрушки',
        raised: 245000,
        target: 500000,
        color: Colors.blue,
        icon: Icons.child_care,
        images: ['🏠', '📚', '🎮'],
      ),
      Organization(
        name: 'Приют для животных "Добрый дом"',
        description: 'Спасаем бездомных животных, лечим их и находим новых хозяев. Средства идут на корм, вакцинацию, стерилизацию и лечение.',
        goal: 'Корм и лечение животных',
        raised: 89000,
        target: 150000,
        color: Colors.orange,
        icon: Icons.pets,
        images: ['🐕', '🐈', '🏥'],
      ),
      Organization(
        name: 'Фонд помощи пожилым "Забота"',
        description: 'Поддерживаем одиноких пожилых людей, помогаем с лекарствами, продуктами и тёплыми вещами. Организуем праздники и общение.',
        goal: 'Тёплые вещи и лекарства',
        raised: 167000,
        target: 300000,
        color: Colors.green,
        icon: Icons.elderly,
        images: ['👴', '💊', '🧥'],
      ),
      Organization(
        name: 'Фонд борьбы с раком "Жизнь"',
        description: 'Помогаем детям и взрослым в борьбе с онкологическими заболеваниями. Средства идут на лечение, реабилитацию и поддержку семей.',
        goal: 'Лечение и реабилитация',
        raised: 456000,
        target: 1000000,
        color: Colors.red,
        icon: Icons.health_and_safety,
        images: ['🏥', '💪', '❤️'],
      ),
      Organization(
        name: 'Экологический фонд "Чистая планета"',
        description: 'Занимаемся очисткой природы, посадкой деревьев и экологическим просвещением. Средства идут на вывоз мусора, саженцы и эко-уроки.',
        goal: 'Посадка деревьев и уборка',
        raised: 34000,
        target: 100000,
        color: Colors.teal,
        icon: Icons.eco,
        images: ['🌳', '♻️', '🌍'],
      ),
      Organization(
        name: 'Центр помощи бездомным "Тепло"',
        description: 'Помогаем бездомным людям вернуться к нормальной жизни. Предоставляем ночлег, питание, одежду и помощь в восстановлении документов.',
        goal: 'Еда и одежда',
        raised: 78000,
        target: 200000,
        color: Colors.brown,
        icon: Icons.house,
        images: ['🍲', '🧥', '📄'],
      ),
    ];
  }

  List<Organization> get _filteredOrganizations {
    return organizations.where((org) {
      final matchesSearch = _searchQuery.isEmpty ||
          org.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          org.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == 'Все' ||
          (_selectedCategory == 'Дети' && org.name.contains('Детский')) ||
          (_selectedCategory == 'Животные' && org.name.contains('Приют')) ||
          (_selectedCategory == 'Пожилые' && org.name.contains('Пожилым')) ||
          (_selectedCategory == 'Медицина' && org.name.contains('рак')) ||
          (_selectedCategory == 'Экология' && org.name.contains('Экологический'));
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Поиск организаций...',
                hintStyle: const TextStyle(fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurple, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 45,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _buildCategoryChip('Все'),
              _buildCategoryChip('Дети'),
              _buildCategoryChip('Животные'),
              _buildCategoryChip('Пожилые'),
              _buildCategoryChip('Медицина'),
              _buildCategoryChip('Экология'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _filteredOrganizations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 50, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'Ничего не найдено',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _filteredOrganizations.length,
                  itemBuilder: (context, index) {
                    return _buildOrganizationCard(_filteredOrganizations[index]);
                  },
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
          });
        },
        selectedColor: Colors.deepPurple.shade100,
        checkmarkColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
    );
  }

  Widget _buildOrganizationCard(Organization org) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: org.color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: org.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(org.icon, size: 26, color: org.color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        org.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        org.goal,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              org.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: org.percentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    color: org.color,
                    minHeight: 5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${org.raised.round()} ₽',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: org.color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'из ${org.target.round()} ₽',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${org.percentage.toStringAsFixed(1)}% собрано',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: () {
                _showDonationDialog(org);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: org.color,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text(
                'Пожертвовать',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDonationDialog(Organization org) {
    double donationAmount = 500;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              titlePadding: const EdgeInsets.all(16),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Row(
                children: [
                  Icon(org.icon, size: 24, color: org.color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Помочь "${org.name}"',
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Выберите сумму пожертвования:',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: [100, 500, 1000, 2000].map((amount) {
                      return _buildQuickAmountButton(
                        amount: amount,
                        currentAmount: donationAmount,
                        onTap: () {
                          setStateDialog(() {
                            donationAmount = amount.toDouble();
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Своя сумма',
                      prefixText: '₽ ',
                      labelStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    style: const TextStyle(fontSize: 14),
                    onChanged: (value) {
                      final amount = double.tryParse(value);
                      if (amount != null) {
                        setStateDialog(() {
                          donationAmount = amount;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: Checkbox(
                          value: false,
                          onChanged: (value) {},
                          activeColor: org.color,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Регулярное пожертвование (ежемесячно)',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.all(12),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена', style: TextStyle(fontSize: 13)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showThankYouDialog(org, donationAmount);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: org.color,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'Пожертвовать ${donationAmount.round()} ₽',
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildQuickAmountButton({
    required int amount,
    required double currentAmount,
    required VoidCallback onTap,
  }) {
    final isSelected = currentAmount == amount;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '$amount ₽',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade800,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _showThankYouDialog(Organization org, double amount) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(16),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: const Text(
            'Спасибо за пожертвование!',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, size: 50, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                'Вы пожертвовали ${amount.round()} ₽',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'в "${org.name}"',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              const Text(
                'Ваша помощь изменит чью-то жизнь к лучшему!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.all(12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Закрыть', style: TextStyle(fontSize: 13)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                mainScreenKey.currentState?.switchToPage(0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: const Text('На главную', style: TextStyle(fontSize: 13)),
            ),
          ],
        );
      },
    );
  }
}