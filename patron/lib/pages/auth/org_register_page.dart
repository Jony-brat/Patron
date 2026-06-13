import 'package:flutter/material.dart';
import 'login_page.dart'; // Добавляем импорт
import 'register_page.dart';

class OrgRegisterPage extends StatefulWidget {
  const OrgRegisterPage({super.key});

  @override
  State<OrgRegisterPage> createState() => _OrgRegisterPageState();
}

class _OrgRegisterPageState extends State<OrgRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _orgNameController = TextEditingController();
  final _innController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;
  String? _selectedCategory;

  final List<String> _categories = [
    'Детские дома',
    'Приюты для животных',
    'Помощь пожилым',
    'Медицина',
    'Экология',
    'Помощь бездомным',
    'Образование',
    'Другое',
  ];

  @override
  void dispose() {
    _orgNameController.dispose();
    _innController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate() && _agreeToTerms && _selectedCategory != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заявка на регистрацию организации отправлена!')),
      );
      // После успешной регистрации возвращаемся на страницу входа
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } else if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите категорию организации')),
      );
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Примите условия пользовательского соглашения')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация организации'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Icon(
                Icons.business,
                size: 50,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 8),
              Text(
                'Зарегистрируйте свою организацию',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              
              // Все поля формы остаются без изменений...
              // (название, ИНН, email, телефон, адрес, категория, описание, пароль)
              
              // ... (вставьте все поля из предыдущей версии) ...
              
              const SizedBox(height: 16),

              // Кнопка регистрации
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Отправить заявку',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 12),

              // Ссылка на вход
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Уже есть аккаунт организации?', style: TextStyle(fontSize: 12)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Войти',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),

              // Ссылка на регистрацию пользователя
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Хотите зарегистрироваться как пользователь?', style: TextStyle(fontSize: 11)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      'Регистрация пользователя',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}