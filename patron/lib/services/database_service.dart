import 'auth_service.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  DatabaseService._init();

  // ========== ПОЛЬЗОВАТЕЛИ ==========
  
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    return AuthService().loginUser(email, password);
  }
  
  Future<Map<String, dynamic>?> getUserById(int id) async {
    return AuthService().getUserById(id);
  }
  
  Future<List<Map<String, dynamic>>> getUserDonations(int userId) async {
    return AuthService().getUserDonations(userId);
  }
  
  Future<int> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    // В демо-версии регистрация только имитируется
    print('Регистрация пользователя: $name, $email');
    return 1;
  }
  
  Future<int> updateUser(int id, {
    String? name,
    String? phone,
    String? password,
  }) async {
    print('Обновление пользователя: $id');
    return 1;
  }
  
  // ========== ОРГАНИЗАЦИИ ==========
  
  Future<Map<String, dynamic>?> loginOrganization(String email, String password) async {
    return AuthService().loginOrganization(email, password);
  }
  
  Future<Map<String, dynamic>?> getOrganizationById(int id) async {
    return AuthService().getOrganizationById(id);
  }
  
  Future<List<Map<String, dynamic>>> getDonationsForOrganization(int orgId) async {
    return AuthService().getDonationsForOrganization(orgId);
  }
  
  Future<List<Map<String, dynamic>>> getPostsForOrganization(int orgId) async {
    return AuthService().getPostsForOrganization(orgId);
  }
  
  Future<List<Map<String, dynamic>>> getAllPosts() async {
    return AuthService().getAllPosts();
  }
  
  Future<List<Map<String, dynamic>>> getAllOrganizations() async {
    return AuthService().getApprovedOrganizations();
  }
  
  Future<int> registerOrganization({
    required String name,
    required String inn,
    required String email,
    required String phone,
    required String address,
    required String description,
    required String category,
    required String password,
  }) async {
    print('Регистрация организации: $name, $email');
    return 1;
  }
  
  Future<int> createDonation({
    required int userId,
    required int orgId,
    required double amount,
    String? comment,
    bool isAnonymous = false,
  }) async {
    print('Пожертвование: $userId -> $orgId : $amount');
    return 1;
  }
  
  Future<int> createPost({
    required int orgId,
    required String title,
    required String content,
    String? imageEmoji,
  }) async {
    print('Создание поста: $title');
    return 1;
  }
  
  Future<int> deletePost(int postId) async {
    print('Удаление поста: $postId');
    return 1;
  }
  
  Future<void> likePost(int postId) async {
    print('Лайк поста: $postId');
  }
}