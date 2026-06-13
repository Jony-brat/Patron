import 'package:flutter/material.dart';

class OrgHomePage extends StatefulWidget {
  const OrgHomePage({super.key});

  @override
  State<OrgHomePage> createState() => _OrgHomePageState();
}

class _OrgHomePageState extends State<OrgHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _postController = TextEditingController();
  bool _isEditing = false;
  
  // Данные организации
  String _orgName = 'Благотворительный фонд "Надежда"';
  String _orgDescription = 'Помогаем детям-сиротам уже 5 лет. Наша миссия - дать каждому ребенку шанс на счастливое детство.';
  String _orgPhone = '+7 (999) 123-45-67';
  String _orgEmail = 'info@nadezhda.ru';
  String _orgAddress = 'г. Москва, ул. Добрая, д. 10';
  
  // Список постов
  List<Map<String, dynamic>> _posts = [
    {
      'title': 'Сбор средств на ремонт',
      'content': 'Друзья, нам очень нужна ваша помощь! Мы собираем средства на ремонт игровой комнаты для детей.',
      'image': '🏠',
      'date': '12.06.2024',
      'likes': 45,
      'comments': 12,
    },
    {
      'title': 'Спасибо за поддержку!',
      'content': 'Благодаря вам мы собрали 150 000 ₽ на покупку игрушек. Спасибо каждому из вас!',
      'image': '🎁',
      'date': '05.06.2024',
      'likes': 89,
      'comments': 23,
    },
    {
      'title': 'Нужны волонтеры',
      'content': 'Приглашаем волонтеров для участия в благотворительной ярмарке 20 июня.',
      'image': '🤝',
      'date': '01.06.2024',
      'likes': 34,
      'comments': 8,
    },
  ];

  void _editOrganization() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveOrganization() {
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Данные организации сохранены!')),
    );
  }

  void _addPost() {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String content = '';
        String image = '❤️';
        
        return AlertDialog(
          title: const Text('Создать пост'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  title = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Содержание',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  content = value;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: image,
                decoration: const InputDecoration(
                  labelText: 'Иконка',
                  border: OutlineInputBorder(),
                ),
                items: ['❤️', '🏠', '🎁', '🤝', '📢', '🌟', '💪', '🎉'].map((emoji) {
                  return DropdownMenuItem(value: emoji, child: Text(emoji));
                }).toList(),
                onChanged: (value) {
                  image = value ?? '❤️';
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty && content.isNotEmpty) {
                  setState(() {
                    _posts.insert(0, {
                      'title': title,
                      'content': content,
                      'image': image,
                      'date': DateTime.now().toString().substring(0, 10),
                      'likes': 0,
                      'comments': 0,
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Пост опубликован!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text('Опубликовать'),
            ),
          ],
        );
      },
    );
  }

  void _deletePost(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Удалить пост?'),
          content: const Text('Это действие нельзя отменить.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _posts.removeAt(index);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Пост удален')),
                );
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Карточка организации
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Информация об организации',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.white),
                      onPressed: _isEditing ? _saveOrganization : _editOrganization,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_isEditing) ...[
                  TextFormField(
                    initialValue: _orgName,
                    decoration: const InputDecoration(
                      labelText: 'Название организации',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => _orgName = value,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _orgDescription,
                    decoration: const InputDecoration(
                      labelText: 'Описание',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    onChanged: (value) => _orgDescription = value,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _orgPhone,
                    decoration: const InputDecoration(
                      labelText: 'Телефон',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => _orgPhone = value,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _orgEmail,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => _orgEmail = value,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _orgAddress,
                    decoration: const InputDecoration(
                      labelText: 'Адрес',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => _orgAddress = value,
                  ),
                ] else ...[
                  Text(_orgName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(_orgDescription, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  Row(children: [const Icon(Icons.phone, size: 16, color: Colors.white70), const SizedBox(width: 8), Text(_orgPhone, style: const TextStyle(color: Colors.white70))]),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.email, size: 16, color: Colors.white70), const SizedBox(width: 8), Text(_orgEmail, style: const TextStyle(color: Colors.white70))]),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.location_on, size: 16, color: Colors.white70), const SizedBox(width: 8), Text(_orgAddress, style: const TextStyle(color: Colors.white70))]),
                ],
              ],
            ),
          ),
          
          // Кнопка создания поста
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: _addPost,
              icon: const Icon(Icons.add),
              label: const Text('Создать пост'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Список постов
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'Новости и события',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          
          const SizedBox(height: 12),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              return _buildPostCard(_posts[index], index);
            },
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text(post['image'], style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['title'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post['date'],
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Редактировать')),
                  const PopupMenuItem(value: 'delete', child: Text('Удалить', style: TextStyle(color: Colors.red))),
                ],
                onSelected: (value) {
                  if (value == 'delete') {
                    _deletePost(index);
                  } else if (value == 'edit') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Редактирование постов скоро появится')),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(post['content'], style: const TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.favorite_border, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text('${post['likes']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              const SizedBox(width: 16),
              Icon(Icons.comment_outlined, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text('${post['comments']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }
}