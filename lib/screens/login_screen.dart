import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/feature_item.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(text: 'owner@gymmaster.com');
  final _password = TextEditingController();
  bool _remember = false;
  bool _pwVisible = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onSignIn() {
    // Replace with real auth later
    Navigator.pushReplacementNamed(context, '/app');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.red700, AppColors.red800],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FeatureItem(
                    iconPath: 'assets/icons/people.svg',
                    title: 'Manage Athletes & Staff',
                    subtitle: 'Track memberships & attendance',
                  ),
                  SizedBox(height: 20),
                  FeatureItem(
                    iconPath: 'assets/icons/analytics.svg',
                    title: 'Financial Analytics',
                    subtitle: 'Revenue & expenses',
                  ),
                  SizedBox(height: 20),
                  FeatureItem(
                    iconPath: 'assets/icons/lock.svg',
                    title: 'Access Control',
                    subtitle: 'Secure entry logs',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 30,
              ),
              child: Column(
                children: [
                  const Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Sign in to your GymMaster owner account',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _email,
                    label: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _password,
                    label: 'Password',
                    obscureText: !_pwVisible,
                    suffix: IconButton(
                      icon: Icon(
                        _pwVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _pwVisible = !_pwVisible),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _remember,
                            activeColor: AppColors.red700,
                            onChanged:
                                (v) => setState(() => _remember = v ?? false),
                          ),
                          const Text('Remember me'),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: AppColors.red700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _onSignIn,
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {},
                    child: const Text.rich(
                      TextSpan(
                        text: "Don’t have access? ",
                        children: [
                          TextSpan(
                            text: "Contact your system administrator",
                            style: TextStyle(
                              color: AppColors.red700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
