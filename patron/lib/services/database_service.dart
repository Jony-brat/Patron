import 'storage_service.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  
  DatabaseService._init();
  
  // ========== ПОЛЬЗОВАТЕЛИ ==========
  
  Future<int> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final id = StorageService.getNextUserId();
    StorageService.addUser({
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'total_donated': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
    return id;
  }
  
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    return StorageService.getUserByEmail(email, password);
  }
  
  Future<Map<String, dynamic>?> getUserById(int id) async {
    return StorageService.getUserById(id);
  }
  
  Future<int> updateUser(int id, {
    String? name,
    String? phone,
    String? password,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (phone != null) updates['phone'] = phone;
    if (password != null) updates['password'] = password;
    StorageService.updateUser(id, updates);
    return 1;
  }
  
  Future<void> updateUserTotalDonated(int userId, double amount) async {
    final user = StorageService.getUserById(userId);
    if (user != null) {
      final currentTotal = (user['total_donated'] as num).toDouble();
      StorageService.updateUser(userId, {
        'total_donated': currentTotal + amount,
      });
    }
  }
  
  // ========== ОРГАНИЗАЦИИ ==========
  
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
    final id = StorageService.getNextOrgId();
    StorageService.addOrganization({
      'id': id,
      'name': name,
      'inn': inn,
      'email': email,
      'phone': phone,
      'address': address,
      'description': description,
      'category': category,
      'password': password,
      'total_received': 0,
      'is_approved': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
    return id;
  }
  
  Future<Map<String, dynamic>?> loginOrganization(String email, String password) async {
    return StorageService.getOrganizationByEmail(email, password);
  }
  
  Future<Map<String, dynamic>?> getOrganizationById(int id) async {
    return StorageService.getOrganizationById(id);
  }
  
  Future<int> updateOrganization(int id, {
    String? name,
    String? description,
    String? phone,
    String? address,
    String? password,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (description != null) updates['description'] = description;
    if (phone != null) updates['phone'] = phone;
    if (address != null) updates['address'] = address;
    if (password != null) updates['password'] = password;
    StorageService.updateOrganization(id, updates);
    return 1;
  }
  
  Future<List<Map<String, dynamic>>> getAllOrganizations() async {
    return StorageService.getAllApprovedOrganizations();
  }
  
  Future<void> updateOrganizationTotalReceived(int orgId, double amount) async {
    final org = StorageService.getOrganizationById(orgId);
    if (org != null) {
      final currentTotal = (org['total_received'] as num).toDouble();
      StorageService.updateOrganization(orgId, {
        'total_received': currentTotal + amount,
      });
    }
  }
  
  // ========== ПОЖЕРТВОВАНИЯ ==========
  
  Future<int> createDonation({
    required int userId,
    required int orgId,
    required double amount,
    String? comment,
    bool isAnonymous = false,
  }) async {
    final id = StorageService.getNextDonationId();
    StorageService.addDonation({
      'id': id,
      'user_id': userId,
      'org_id': orgId,
      'amount': amount,
      'comment': comment,
      'is_anonymous': isAnonymous,
      'created_at': DateTime.now().toIso8601String(),
    });
    
    await updateUserTotalDonated(userId, amount);
    await updateOrganizationTotalReceived(orgId, amount);
    
    return id;
  }
  
  Future<List<Map<String, dynamic>>> getDonationsForOrganization(int orgId) async {
    return StorageService.getDonationsForOrganization(orgId);
  }
  
  Future<List<Map<String, dynamic>>> getUserDonations(int userId) async {
    return StorageService.getUserDonations(userId);
  }
  
  // ========== ПОСТЫ ==========
  
  Future<int> createPost({
    required int orgId,
    required String title,
    required String content,
    String? imageEmoji,
  }) async {
    final id = StorageService.getNextPostId();
    StorageService.addPost({
      'id': id,
      'org_id': orgId,
      'title': title,
      'content': content,
      'image_emoji': imageEmoji ?? '❤️',
      'likes': 0,
      'comments': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
    return id;
  }
  
  Future<List<Map<String, dynamic>>> getPostsForOrganization(int orgId) async {
    return StorageService.getPostsForOrganization(orgId);
  }
  
  Future<List<Map<String, dynamic>>> getAllPosts() async {
    return StorageService.getAllPosts();
  }
  
  Future<int> deletePost(int postId) async {
    StorageService.deletePost(postId);
    return 1;
  }
  
  Future<void> likePost(int postId) async {
    StorageService.likePost(postId);
  }
}