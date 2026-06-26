import 'package:flutter/material.dart';
import 'package:hackathon/app/routes/app_routes.dart';
import 'package:hackathon/features/auth/presentation/viewmodels/login_view_model.dart';
import 'package:hackathon/features/task/presentation/viewmodels/task_view_model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController(
    text: 'admin@gmail.com',
  );

  final TextEditingController _passwordController = TextEditingController(
    text: '123456',
  );

  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    final viewModel = context.read<LoginViewModel>();

    final success = await viewModel.login(
      username: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      if (context.mounted) {
        context.read<TaskViewModel>().loadTasks();
      }
      Navigator.pushReplacementNamed(context, AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Soft light-grey background
      body: Stack(
        children: [
          // Background decorative patterns
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xFFEEF2F6),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFFEEF2F6),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 3D Character Stack
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 180,
                            height: 180,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE0E7FF), // Light indigo background circle
                              shape: BoxShape.circle,
                            ),
                          ),
                          Image.asset(
                            'assets/images/student_illustration.png',
                            height: 200,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.account_circle,
                                size: 180,
                                color: Color(0xFF6366F1),
                              );
                            },
                          ),
                          // Small Floating Badges (similar to mockups)
                          Positioned(
                            left: 8,
                            top: 80,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.check_circle_outline,
                                color: Color(0xFF6366F1),
                                size: 18,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 60,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.calendar_today_outlined,
                                color: Color(0xFF3B82F6),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Title Text
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          children: [
                            const TextSpan(
                              text: 'Student Task\n',
                              style: TextStyle(color: Colors.black87),
                            ),
                            TextSpan(
                              text: 'Manager',
                              style: TextStyle(color: theme.colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Quản lý nhiệm vụ học tập hiệu quả mỗi ngày',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Email Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: TextField(
                          controller: _emailController,
                          enabled: !viewModel.isLoading,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined, color: Colors.black45),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Helper Credentials Hint
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            'deming@gmail.com / 123456',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Password Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: TextField(
                          controller: _passwordController,
                          enabled: !viewModel.isLoading,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Mật khẩu',
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.black45),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 18),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.black38,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Checkbox - Remember Me
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _rememberMe = val ?? true;
                              });
                            },
                          ),
                          const Text(
                            'Ghi nhớ đăng nhập',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Error message if any
                      if (viewModel.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            viewModel.errorMessage!,
                            style: TextStyle(
                              color: theme.colorScheme.error,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      // Login Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: TextButton(
                          onPressed: viewModel.isLoading ? null : _submitLogin,
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: viewModel.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Đăng nhập',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Forgot Password Link
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
