class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Тестовые данные пользователей
  final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'name': 'Иван Иванов',
      'email': 'user@test.com',
      'password': '123456',
      'phone': '+7 (999) 123-45-67',
      'total_donated': 5000,
      'created_at': '2024-01-15',
    },
    {
      'id': 2,
      'name': 'Мария Петрова',
      'email': 'maria@test.com',
      'password': '123456',
      'phone': '+7 (999) 234-56-78',
      'total_donated': 12000,
      'created_at': '2024-02-20',
    },
    {
      'id': 3,
      'name': 'Алексей Смирнов',
      'email': 'alex@test.com',
      'password': '123456',
      'phone': '+7 (999) 345-67-89',
      'total_donated': 3000,
      'created_at': '2024-03-10',
    },
  ];

  // Тестовые данные организаций
  final List<Map<String, dynamic>> _organizations = [
    {
      'id': 1,
      'name': 'Благотворительный фонд "Надежда"',
      'email': 'org@test.com',
      'password': '123456',
      'phone': '+7 (999) 987-65-43',
      'address': 'г. Москва, ул. Добрая, д. 10',
      'description': 'Помогаем детям-сиротам уже 5 лет. Наша миссия - дать каждому ребенку шанс на счастливое детство.',
      'category': 'Детские дома',
      'total_received': 150000,
      'is_approved': 1,
      'created_at': '2023-01-10',
    },
    {
      'id': 2,
      'name': 'Приют для животных "Добрый дом"',
      'email': 'pets@test.com',
      'password': '123456',
      'phone': '+7 (999) 876-54-32',
      'address': 'г. Санкт-Петербург, ул. Звериная, д. 5',
      'description': 'Спасаем бездомных животных, лечим их и находим новых хозяев уже 3 года.',
      'category': 'Приюты для животных',
      'total_received': 85000,
      'is_approved': 1,
      'created_at': '2023-05-15',
    },
    {
      'id': 3,
      'name': 'Фонд помощи пожилым "Забота"',
      'email': 'elderly@test.com',
      'password': '123456',
      'phone': '+7 (999) 765-43-21',
      'address': 'г. Казань, ул. Мира, д. 15',
      'description': 'Поддерживаем одиноких пожилых людей, помогаем с лекарствами и продуктами.',
      'category': 'Помощь пожилым',
      'total_received': 67000,
      'is_approved': 0, // Не одобрена
      'created_at': '2024-04-01',
    },
  ];

  // Тестовые пожертвования
  final List<Map<String, dynamic>> _donations = [
    {
      'id': 1,
      'user_id': 1,
      'org_id': 1,
      'amount': 5000,
      'comment': 'На добрые дела! Спасибо за вашу работу 🙏',
      'is_anonymous': false,
      'created_at': '2024-06-15 14:30',
    },
    {
      'id': 2,
      'user_id': 2,
      'org_id': 1,
      'amount': 3000,
      'comment': 'Пусть у детей будет счастливое детство',
      'is_anonymous': false,
      'created_at': '2024-06-14 09:15',
    },
    {
      'id': 3,
      'user_id': 1,
      'org_id': 2,
      'amount': 2000,
      'comment': 'Для животных с любовью ❤️',
      'is_anonymous': false,
      'created_at': '2024-06-13 18:45',
    },
    {
      'id': 4,
      'user_id': 3,
      'org_id': 1,
      'amount': 1000,
      'comment': '',
      'is_anonymous': true,
      'created_at': '2024-06-12 11:20',
    },
  ];

  // Тестовые посты
  final List<Map<String, dynamic>> _posts = [
    {
      'id': 1,
      'org_id': 1,
      'title': 'Сбор средств на ремонт игровой комнаты',
      'content': 'Друзья, нам очень нужна ваша помощь! Мы собираем средства на ремонт игровой комнаты для детей. Нужно покрасить стены, купить новые игрушки и мебель.',
      'image_emoji': '🏠',
      'likes': 45,
      'comments': 12,
      'created_at': '2024-06-10',
    },
    {
      'id': 2,
      'org_id': 1,
      'title': 'Спасибо за поддержку!',
      'content': 'Благодаря вам мы собрали 150 000 ₽ на покупку игрушек. Спасибо каждому из вас! Ваши пожертвования уже меняют жизни детей.',
      'image_emoji': '🎁',
      'likes': 89,
      'comments': 23,
      'created_at': '2024-06-05',
    },
    {
      'id': 3,
      'org_id': 1,
      'title': 'Нужны волонтеры на ярмарку',
      'content': 'Приглашаем волонтеров для участия в благотворительной ярмарке 20 июня. Нужна помощь в организации, проведении мастер-классов и работе с детьми.',
      'image_emoji': '🤝',
      'likes': 34,
      'comments': 8,
      'created_at': '2024-06-01',
    },
    {
      'id': 4,
      'org_id': 2,
      'title': 'Спасите Барсика!',
      'content': 'Коту Барсику срочно нужна операция. Собрали уже 15 000 ₽ из 30 000 ₽. Помогите нам спасти жизнь!',
      'image_emoji': '🐱',
      'likes': 67,
      'comments': 15,
      'created_at': '2024-06-08',
    },
  ];

  // ========== ПОЛЬЗОВАТЕЛИ ==========
  
  List<Map<String, dynamic>> getUsers() => _users;
  
  Map<String, dynamic>? loginUser(String email, String password) {
    try {
      return _users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
      );
    } catch (e) {
      return null;
    }
  }
  
  Map<String, dynamic>? getUserById(int id) {
    try {
      return _users.firstWhere((u) => u['id'] == id);
    } catch (e) {
      return null;
    }
  }
  
  // ========== ОРГАНИЗАЦИИ ==========
  
  List<Map<String, dynamic>> getOrganizations() => _organizations;
  
  Map<String, dynamic>? loginOrganization(String email, String password) {
    try {
      return _organizations.firstWhere(
        (o) => o['email'] == email && o['password'] == password && o['is_approved'] == 1,
      );
    } catch (e) {
      return null;
    }
  }
  
  Map<String, dynamic>? getOrganizationById(int id) {
    try {
      return _organizations.firstWhere((o) => o['id'] == id);
    } catch (e) {
      return null;
    }
  }
  
  List<Map<String, dynamic>> getApprovedOrganizations() {
    return _organizations.where((o) => o['is_approved'] == 1).toList();
  }
  
  // ========== ПОЖЕРТВОВАНИЯ ==========
  
  List<Map<String, dynamic>> getDonations() => _donations;
  
  List<Map<String, dynamic>> getDonationsForOrganization(int orgId) {
    return _donations
        .where((d) => d['org_id'] == orgId)
        .map((d) {
          final user = getUserById(d['user_id']);
          return {
            ...d,
            'user_name': d['is_anonymous'] ? 'Анонимный пользователь' : (user?['name'] ?? 'Пользователь'),
          };
        })
        .toList();
  }
  
  List<Map<String, dynamic>> getUserDonations(int userId) {
    return _donations
        .where((d) => d['user_id'] == userId)
        .map((d) {
          final org = getOrganizationById(d['org_id']);
          return {
            ...d,
            'org_name': org?['name'] ?? 'Организация',
          };
        })
        .toList();
  }
  
  // ========== ПОСТЫ ==========
  
  List<Map<String, dynamic>> getPosts() => _posts;
  
  List<Map<String, dynamic>> getPostsForOrganization(int orgId) {
    return _posts.where((p) => p['org_id'] == orgId).toList();
  }
  
  List<Map<String, dynamic>> getAllPosts() {
    return _posts
        .where((p) {
          final org = getOrganizationById(p['org_id']);
          return org?['is_approved'] == 1;
        })
        .map((p) {
          final org = getOrganizationById(p['org_id']);
          return {
            ...p,
            'org_name': org?['name'] ?? 'Организация',
          };
        })
        .toList();
  }
}