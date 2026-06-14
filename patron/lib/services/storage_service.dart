import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();
  
  static SharedPreferences? _prefs;
  
  // Инициализация
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('✅ StorageService инициализирован');
    
    // Добавляем тестовые данные если их нет
    await _addTestDataIfEmpty();
  }
  
  // Добавление тестовых данных
  static Future<void> _addTestDataIfEmpty() async {
    final users = getUsers();
    if (users.isEmpty) {
      print('📝 Добавление тестовых данных...');
      
      // Тестовый пользователь
      addUser({
        'id': 1,
        'name': 'Иван Иванов',
        'email': 'user@test.com',
        'phone': '+7 (999) 123-45-67',
        'password': '123456',
        'total_donated': 5000,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // Тестовая организация
      addOrganization({
        'id': 1,
        'name': 'Благотворительный фонд "Надежда"',
        'inn': '1234567890',
        'email': 'org@test.com',
        'phone': '+7 (999) 987-65-43',
        'address': 'г. Москва, ул. Добрая, д. 10',
        'description': 'Помогаем детям-сиротам уже 5 лет',
        'category': 'Детские дома',
        'password': '123456',
        'total_received': 5000,
        'is_approved': 1,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // Тестовое пожертвование
      addDonation({
        'id': 1,
        'user_id': 1,
        'org_id': 1,
        'amount': 5000,
        'comment': 'На добрые дела!',
        'is_anonymous': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // Тестовый пост
      addPost({
        'id': 1,
        'org_id': 1,
        'title': 'Сбор средств на ремонт',
        'content': 'Друзья, нам очень нужна ваша помощь!',
        'image_emoji': '🏠',
        'likes': 45,
        'comments': 12,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      print('✅ Тестовые данные добавлены');
    }
  }
  
  // ========== ПОЛЬЗОВАТЕЛИ ==========
  
  static List<Map<String, dynamic>> getUsers() {
    final String? data = _prefs?.getString('users');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }
  
  static void saveUsers(List<Map<String, dynamic>> users) {
    _prefs?.setString('users', json.encode(users));
  }
  
  static void addUser(Map<String, dynamic> user) {
    final users = getUsers();
    users.add(user);
    saveUsers(users);
  }
  
  static void updateUser(int id, Map<String, dynamic> updates) {
    final users = getUsers();
    final index = users.indexWhere((u) => u['id'] == id);
    if (index != -1) {
      users[index] = {...users[index], ...updates};
      saveUsers(users);
    }
  }
  
  static Map<String, dynamic>? getUserByEmail(String email, String password) {
    final users = getUsers();
    try {
      return users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
      );
    } catch (e) {
      return null;
    }
  }
  
  static Map<String, dynamic>? getUserById(int id) {
    final users = getUsers();
    try {
      return users.firstWhere((u) => u['id'] == id);
    } catch (e) {
      return null;
    }
  }
  
  static int getNextUserId() {
    final users = getUsers();
    if (users.isEmpty) return 1;
    return (users.map((u) => u['id'] as int).reduce((a, b) => a > b ? a : b)) + 1;
  }
  
  // ========== ОРГАНИЗАЦИИ ==========
  
  static List<Map<String, dynamic>> getOrganizations() {
    final String? data = _prefs?.getString('organizations');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }
  
  static void saveOrganizations(List<Map<String, dynamic>> orgs) {
    _prefs?.setString('organizations', json.encode(orgs));
  }
  
  static void addOrganization(Map<String, dynamic> org) {
    final orgs = getOrganizations();
    orgs.add(org);
    saveOrganizations(orgs);
  }
  
  static void updateOrganization(int id, Map<String, dynamic> updates) {
    final orgs = getOrganizations();
    final index = orgs.indexWhere((o) => o['id'] == id);
    if (index != -1) {
      orgs[index] = {...orgs[index], ...updates};
      saveOrganizations(orgs);
    }
  }
  
  static Map<String, dynamic>? getOrganizationByEmail(String email, String password) {
    final orgs = getOrganizations();
    try {
      return orgs.firstWhere(
        (o) => o['email'] == email && o['password'] == password && o['is_approved'] == 1,
      );
    } catch (e) {
      return null;
    }
  }
  
  static Map<String, dynamic>? getOrganizationById(int id) {
    final orgs = getOrganizations();
    try {
      return orgs.firstWhere((o) => o['id'] == id);
    } catch (e) {
      return null;
    }
  }
  
  static List<Map<String, dynamic>> getAllApprovedOrganizations() {
    final orgs = getOrganizations();
    return orgs.where((o) => o['is_approved'] == 1).toList();
  }
  
  static int getNextOrgId() {
    final orgs = getOrganizations();
    if (orgs.isEmpty) return 1;
    return (orgs.map((o) => o['id'] as int).reduce((a, b) => a > b ? a : b)) + 1;
  }
  
  // ========== ПОЖЕРТВОВАНИЯ ==========
  
  static List<Map<String, dynamic>> getDonations() {
    final String? data = _prefs?.getString('donations');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }
  
  static void saveDonations(List<Map<String, dynamic>> donations) {
    _prefs?.setString('donations', json.encode(donations));
  }
  
  static void addDonation(Map<String, dynamic> donation) {
    final donations = getDonations();
    donations.add(donation);
    saveDonations(donations);
  }
  
  static List<Map<String, dynamic>> getDonationsForOrganization(int orgId) {
    final donations = getDonations();
    final result = donations.where((d) => d['org_id'] == orgId).toList();
    
    // Добавляем имена пользователей
    return result.map((d) {
      final user = getUserById(d['user_id']);
      return {
        ...d,
        'user_name': d['is_anonymous'] ? 'Анонимный пользователь' : (user?['name'] ?? 'Пользователь'),
      };
    }).toList();
  }
  
  static List<Map<String, dynamic>> getUserDonations(int userId) {
    final donations = getDonations();
    final result = donations.where((d) => d['user_id'] == userId).toList();
    
    // Добавляем названия организаций
    return result.map((d) {
      final org = getOrganizationById(d['org_id']);
      return {
        ...d,
        'org_name': org?['name'] ?? 'Организация',
      };
    }).toList();
  }
  
  static int getNextDonationId() {
    final donations = getDonations();
    if (donations.isEmpty) return 1;
    return (donations.map((d) => d['id'] as int).reduce((a, b) => a > b ? a : b)) + 1;
  }
  
  // ========== ПОСТЫ ==========
  
  static List<Map<String, dynamic>> getPosts() {
    final String? data = _prefs?.getString('posts');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }
  
  static void savePosts(List<Map<String, dynamic>> posts) {
    _prefs?.setString('posts', json.encode(posts));
  }
  
  static void addPost(Map<String, dynamic> post) {
    final posts = getPosts();
    posts.insert(0, post); // Добавляем в начало
    savePosts(posts);
  }
  
  static List<Map<String, dynamic>> getPostsForOrganization(int orgId) {
    final posts = getPosts();
    return posts.where((p) => p['org_id'] == orgId).toList();
  }
  
  static List<Map<String, dynamic>> getAllPosts() {
    final posts = getPosts();
    final result = posts.where((p) {
      final org = getOrganizationById(p['org_id']);
      return org?['is_approved'] == 1;
    }).toList();
    
    return result.map((p) {
      final org = getOrganizationById(p['org_id']);
      return {
        ...p,
        'org_name': org?['name'] ?? 'Организация',
      };
    }).toList();
  }
  
  static void deletePost(int postId) {
    final posts = getPosts();
    posts.removeWhere((p) => p['id'] == postId);
    savePosts(posts);
  }
  
  static int getNextPostId() {
    final posts = getPosts();
    if (posts.isEmpty) return 1;
    return (posts.map((p) => p['id'] as int).reduce((a, b) => a > b ? a : b)) + 1;
  }
  
  static void likePost(int postId) {
    final posts = getPosts();
    final index = posts.indexWhere((p) => p['id'] == postId);
    if (index != -1) {
      posts[index]['likes'] = (posts[index]['likes'] as int) + 1;
      savePosts(posts);
    }
  }
}