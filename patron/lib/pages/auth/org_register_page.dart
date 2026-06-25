import 'package:flutter/material.dart';
import 'package:patron/services/database_service.dart';
import 'register_page.dart';
import 'login_page.dart';

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
  bool _isLoading = false;
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

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите категорию организации')),
      );
      return;
    }
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Примите условия пользовательского соглашения')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await DatabaseService.instance.registerOrganization(
        name: _orgNameController.text,
        inn: _innController.text,
        email: _emailController.text.trim(),
        phone: _phoneController.text,
        address: _addressController.text,
        description: _descriptionController.text,
        category: _selectedCategory!,
        password: _passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заявка на регистрацию отправлена!')),
      );

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
              const Icon(Icons.business, size: 50, color: Colors.deepPurple),
              const SizedBox(height: 8),
              Text('Зарегистрируйте свою организацию',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _orgNameController,
                decoration: InputDecoration(
                  labelText: 'Название организации',
                  labelStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.business, size: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(fontSize: 13),
                validator: (value) => value == null || value.isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _innController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'ИНН организации',
                  labelStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.numbers, size: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(fontSize: 13),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Введите ИНН';
                  if (value.length != 10 && value.length != 12) return '10 или 12 цифр';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email организации',
                  labelStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.email, size: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(fontSize: 13),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Введите email';
                  if (!value.contains('@')) return 'Некорректный email';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Телефон организации',
                  labelStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.phone, size: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(fontSize: 13),
                validator: (value) => value == null || value.length < 10 ? 'Некорректный телефон' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Адрес организации',
                  labelStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.location_on, size: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(fontSize: 13),
                validator: (value) => value == null || value.isEmpty ? 'Введите адрес' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Категория организации',
                  labelStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.category, size: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category, style: const TextStyle(fontSize: 13)))).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Описание деятельности',
                  labelStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.description, size: 18),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(fontSize: 13),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Введите описание';
                  if (value.length < 20) return 'Минимум 20 символов';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  labelStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.lock, size: 18),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, size: 18),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(fontSize: 13),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Введите пароль';
                  if (value.length < 6) return 'Минимум 6 символов';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Подтверждение пароля',
                  labelStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.lock_outline, size: 18),
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off, size: 18),
                    onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(fontSize: 13),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Подтвердите пароль';
                  if (value != _passwordController.text) return 'Пароли не совпадают';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                      activeColor: Colors.deepPurple,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 6, right: 4),
                        child: Text(
                          'Я согласен с условиями для организаций и правилами платформы',
                          style: TextStyle(fontSize: 11, color: Colors.black87),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('Заявка будет рассмотрена модератором',
                          style: TextStyle(fontSize: 10, color: Colors.blue.shade700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Отправить заявку', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  ),
                  child: const Text('Зарегистрироваться как пользователь', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}