import 'package:flutter/material.dart';
import 'package:patron/main.dart';
import 'package:patron/services/database_service.dart';
import 'package:patron/pages/auth/auth_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _donations = [];
  bool _isLoading = true;
  bool _isEditing = false;
  String? _errorMessage;
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    print('📱 Загрузка профиля, currentUserId = $currentUserId');
    
    if (currentUserId == null) {
      print('❌ currentUserId = null, пользователь не авторизован');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Пользователь не авторизован';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Загружаем данные пользователя
      _userData = await DatabaseService.instance.getUserById(currentUserId!);
      print('📦 Данные пользователя: $_userData');
      
      if (_userData == null) {
        setState(() {
          _errorMessage = 'Пользователь не найден';
        });
      } else {
        // Загружаем историю пожертвований
        _donations = await DatabaseService.instance.getUserDonations(currentUserId!);
        print('📦 История пожертвований: ${_donations.length} записей');
        
        _nameController.text = _userData!['name'] ?? '';
        _phoneController.text = _userData!['phone'] ?? '';
      }
    } catch (e) {
      print('❌ Ошибка загрузки: $e');
      setState(() {
        _errorMessage = 'Ошибка загрузки данных: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveChanges() async {
    if (currentUserId == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await DatabaseService.instance.updateUser(
        currentUserId!,
        name: _nameController.text,
        phone: _phoneController.text,
      );
      
      await _loadUserData();
      
      setState(() {
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Данные обновлены!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Показываем индикатор загрузки
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Загрузка профиля...'),
          ],
        ),
      );
    }
    
    // Показываем ошибку
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Возвращаемся на страницу авторизации
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                  (route) => false,
                );
              },
              child: const Text('Войти снова'),
            ),
          ],
        ),
      );
    }
    
    if (_userData == null) {
      return const Center(
        child: Text('Нет данных пользователя'),
      );
    }
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Аватар и имя
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 16),
                if (_isEditing)
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Ваше имя',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.center,
                  )
                else
                  Text(
                    _userData!['name'] ?? 'Без имени',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  _userData!['email'] ?? 'email@example.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Всего пожертвовано: ${(_userData!['total_donated'] ?? 0).round()} ₽',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Контактная информация
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.contact_phone, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Text(
                          'Контактная информация',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Телефон'),
                      subtitle: _isEditing
                          ? TextField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                hintText: 'Номер телефона',
                                border: InputBorder.none,
                              ),
                            )
                          : Text(_userData!['phone'] ?? 'Не указан'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Дата регистрации'),
                      subtitle: Text(_userData!['created_at']?.toString().substring(0, 10) ?? 'Неизвестно'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // История пожертвований
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.history, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Text(
                          'История пожертвований',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_donations.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.favorite_border, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('У вас пока нет пожертвований'),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _donations.length,
                        itemBuilder: (context, index) {
                          final donation = _donations[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.shade100,
                              child: const Icon(Icons.favorite, size: 20, color: Colors.green),
                            ),
                            title: Text(
                              donation['org_name'] ?? 'Организация',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              donation['comment'] ?? 'Без комментария',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '+ ${donation['amount']?.round()} ₽',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  donation['created_at']?.toString().substring(0, 10) ?? '',
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Кнопка редактирования/сохранения
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _isEditing ? _saveChanges : () {
                setState(() {
                  _isEditing = true;
                });
              },
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              label: Text(_isEditing ? 'Сохранить' : 'Редактировать профиль'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}