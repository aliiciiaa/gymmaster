import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/feature_item.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nom = TextEditingController();
  final _prenom = TextEditingController();
  final _email = TextEditingController();
  final _salle = TextEditingController();
  final _identifiant = TextEditingController();
  final _numero = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _pwVisible = false;
  bool _pwConfirmVisible = false;

  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _nom.dispose();
    _prenom.dispose();
    _email.dispose();
    _salle.dispose();
    _identifiant.dispose();
    _numero.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  // ---------- VALIDATIONS ----------

  bool _isAlphabetic(String value) {
    return RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value);
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value);
  }

  bool _isValidPhone(String value) {
    return RegExp(r'^[0-9]{10}$').hasMatch(value);
  }

  bool _validatePassword(String pw) {
    final hasUpper = pw.contains(RegExp(r'[A-Z]'));
    final hasDigit = pw.contains(RegExp(r'[0-9]'));
    final hasSpecial = pw.contains(RegExp(r'[@#$%^&+=!?.]'));
    final hasMinLength = pw.length >= 8;
    return hasUpper && hasDigit && hasSpecial && hasMinLength;
  }

  bool _passwordsMatch() {
    return _password.text == _confirmPassword.text;
  }

  // ---------- REGISTER FUNCTION ----------
  Future<void> _onRegister() async {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    // Champs obligatoires
    if (_nom.text.isEmpty ||
        _prenom.text.isEmpty ||
        _email.text.isEmpty ||
        _salle.text.isEmpty ||
        _identifiant.text.isEmpty ||
        _numero.text.isEmpty ||
        _password.text.isEmpty ||
        _confirmPassword.text.isEmpty) {
      setState(() {
        _errorMessage = "Tous les champs sont obligatoires";
      });
      return;
    }

    // Nom & Prénom alphabetique
    if (!_isAlphabetic(_nom.text) || !_isAlphabetic(_prenom.text)) {
      setState(() {
        _errorMessage = "Nom et Prénom doivent contenir uniquement des lettres";
      });
      return;
    }

    // Email format
    if (!_isValidEmail(_email.text)) {
      setState(() {
        _errorMessage = "Email invalide";
      });
      return;
    }

    // Numéro : 10 chiffres
    if (!_isValidPhone(_numero.text)) {
      setState(() {
        _errorMessage = "Le numéro doit contenir exactement 10 chiffres";
      });
      return;
    }

    // Mot de passe sécurisé
    if (!_validatePassword(_password.text)) {
      setState(() {
        _errorMessage =
            "Mot de passe : 8+ caractères, 1 majuscule, 1 chiffre, 1 caractère spécial";
      });
      return;
    }

    // Confirmation
    if (!_passwordsMatch()) {
      setState(() {
        _errorMessage = "Les mots de passe ne correspondent pas";
      });
      return;
    }

    final url = Uri.parse("http://localhost/gymapi/register.php");

    try {
      final response = await http.post(url, body: {
        "nom": _nom.text.trim(),
        "prenom": _prenom.text.trim(),
        "email": _email.text.trim(),
        "salle_sport": _salle.text.trim(),
        "identifiant_unique": _identifiant.text.trim(),
        "numero": _numero.text.trim(),
        "password": _password.text.trim(),
      });

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        setState(() {
          _successMessage = data["message"];
        });

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, '/app');
        });
      } else {
        setState(() {
          _errorMessage = data["message"];
        });
      }
    } catch (e) {
      print("Error connecting to PHP: $e");
      setState(() {
        _errorMessage = "Erreur de connexion. WAMP est-il lancé ?";
      });
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
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
                    title: 'Join GymMaster',
                    subtitle: 'Create your account',
                  ),
                ],
              ),
            ),

            // FORM
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 30),
              child: Column(
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  CustomTextField(controller: _nom, label: "Nom"),
                  const SizedBox(height: 12),

                  CustomTextField(controller: _prenom, label: "Prénom"),
                  const SizedBox(height: 12),

                  CustomTextField(
                      controller: _email,
                      label: "Email",
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),

                  CustomTextField(controller: _salle, label: "Salle de Sport"),
                  const SizedBox(height: 12),

                  CustomTextField(
                      controller: _identifiant, label: "Identifiant Unique"),
                  const SizedBox(height: 12),

                  CustomTextField(
                      controller: _numero,
                      label: "Numéro",
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 12),

                  // PASSWORD
                  CustomTextField(
                    controller: _password,
                    label: "Password",
                    obscureText: !_pwVisible,
                    suffix: IconButton(
                      icon: Icon(
                          _pwVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _pwVisible = !_pwVisible),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // CONFIRM PASSWORD
                  CustomTextField(
                    controller: _confirmPassword,
                    label: "Confirm Password",
                    obscureText: !_pwConfirmVisible,
                    suffix: IconButton(
                      icon: Icon(_pwConfirmVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => setState(
                          () => _pwConfirmVisible = !_pwConfirmVisible),
                    ),
                  ),

                  const SizedBox(height: 18),

                  if (_errorMessage != null)
                    Text(_errorMessage!,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                  if (_successMessage != null)
                    Text(_successMessage!,
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 18),

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _onRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red700,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
