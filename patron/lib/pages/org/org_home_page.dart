import 'package:flutter/material.dart';
import 'package:patron/main.dart';
import 'package:patron/services/database_service.dart';

class OrgHomePage extends StatefulWidget {
  const OrgHomePage({super.key});

  @override
  State<OrgHomePage> createState() => _OrgHomePageState();
}

class _OrgHomePageState extends State<OrgHomePage> {
  Map<String, dynamic>? _orgData;
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;
  bool _isEditing = false;
  
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _postTitleController = TextEditingController();
  final _postContentController = TextEditingController();
  String _selectedEmoji = '❤️';

  @override
  void initState() {
    super.initState();
    _loadOrgData();
  }

  Future<void> _loadOrgData() async {
    if (currentOrgId == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      _orgData = await DatabaseService.instance.getOrganizationById(currentOrgId!);
      _posts = await DatabaseService.instance.getPostsForOrganization(currentOrgId!);
      
      if (_orgData != null) {
        _nameController.text = _orgData!['name'];
        _descriptionController.text = _orgData!['description'];
        _phoneController.text = _orgData!['phone'];
        _addressController.text = _orgData!['address'];
      }
    } catch (e) {
      print('Ошибка: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveOrgChanges() async {
    if (currentOrgId == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await DatabaseService.instance.updateOrganization(
        currentOrgId!,
        name: _nameController.text,
        description: _descriptionController.text,
        phone: _phoneController.text,
        address: _addressController.text,
      );
      
      await _loadOrgData();
      
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

  Future<void> _createPost() async {
    if (_postTitleController.text.isEmpty || _postContentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните заголовок и содержание')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await DatabaseService.instance.createPost(
        orgId: currentOrgId!,
        title: _postTitleController.text,
        content: _postContentController.text,
        imageEmoji: _selectedEmoji,
      );
      
      _postTitleController.clear();
      _postContentController.clear();
      _selectedEmoji = '❤️';
      
      await _loadOrgData();
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пост опубликован!')),
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

  Future<void> _deletePost(int postId) async {
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
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  _isLoading = true;
                });
                
                try {
                  await DatabaseService.instance.deletePost(postId);
                  await _loadOrgData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Пост удален')),
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
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Создать пост'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _postTitleController,
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _postContentController,
                decoration: const InputDecoration(
                  labelText: 'Содержание',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedEmoji,
                decoration: const InputDecoration(
                  labelText: 'Иконка',
                  border: OutlineInputBorder(),
                ),
                items: ['❤️', '🏠', '🎁', '🤝', '📢', '🌟', '💪', '🎉'].map((emoji) {
                  return DropdownMenuItem(value: emoji, child: Text(emoji));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEmoji = value ?? '❤️';
                  });
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
              onPressed: _createPost,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text('Опубликовать'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_orgData == null) {
      return const Center(child: Text('Организация не найдена'));
    }
    
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
                      onPressed: _isEditing ? _saveOrgChanges : () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_isEditing) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Название организации',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Описание',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Телефон',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Адрес',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ] else ...[
                  Text(_orgData!['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(_orgData!['description'], style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  Row(children: [const Icon(Icons.phone, size: 16, color: Colors.white70), const SizedBox(width: 8), Text(_orgData!['phone'], style: const TextStyle(color: Colors.white70))]),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.email, size: 16, color: Colors.white70), const SizedBox(width: 8), Text(_orgData!['email'], style: const TextStyle(color: Colors.white70))]),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.location_on, size: 16, color: Colors.white70), const SizedBox(width: 8), Text(_orgData!['address'], style: const TextStyle(color: Colors.white70))]),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Всего получено: ${_orgData!['total_received']?.round() ?? 0} ₽',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Кнопка создания поста
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: _showCreatePostDialog,
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
          
          if (_posts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.post_add, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('У вас пока нет постов'),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
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
                            child: Center(child: Text(post['image_emoji'] ?? '❤️', style: const TextStyle(fontSize: 24))),
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
                                  post['created_at']?.substring(0, 10) ?? '',
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 'delete', child: Text('Удалить', style: TextStyle(color: Colors.red))),
                            ],
                            onSelected: (value) {
                              if (value == 'delete') {
                                _deletePost(post['id']);
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
              },
            ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}