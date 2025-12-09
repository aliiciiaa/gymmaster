import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _pwVisible = false;

  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // --------------------------
  // LOGIN FLUTTER → PHP
  // --------------------------
  Future<void> _onSignIn() async {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    // Champs obligatoires
    if (_email.text.isEmpty || _password.text.isEmpty) {
      setState(() {
        _errorMessage = "Veuillez remplir tous les champs.";
      });
      return;
    }

    // Format email
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(_email.text.trim())) {
      setState(() {
        _errorMessage = "Email invalide.";
      });
      return;
    }

    final url = Uri.parse("http://localhost/gymapi/login.php");

    try {
      final response = await http.post(url, body: {
        "email": _email.text.trim(),
        "password": _password.text.trim(),
      });

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        setState(() => _successMessage = "Connexion réussie !");

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(
  context,
  '/app',
  arguments: data["user"]["id"],  // ← ID envoyé
);

        });
      } else {
        setState(() => _errorMessage = data["message"]);
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Erreur de connexion. Vérifiez WAMP.";
      });
    }
  }

  // --------------------------
  // UI
  // --------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER ROUGE
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

            // FORMULAIRE LOGIN
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 30),
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
                          _pwVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _pwVisible = !_pwVisible),
                    ),
                  ),

                  // Messages d’erreur ou succès
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(_errorMessage!,
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                    ),

                  if (_successMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(_successMessage!,
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold)),
                    ),

                  const SizedBox(height: 18),

                  // BOUTON LOGIN
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
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Vous n’avez pas de compte ? ",
                        children: [
                          TextSpan(
                              text: "Créez-en un",
                              style: TextStyle(
                                  color: AppColors.red700,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
