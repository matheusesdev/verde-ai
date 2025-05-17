// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, insira seu e-mail.';
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegex.hasMatch(value)) return 'Por favor, insira um e-mail válido (ex: nome@dominio.com).';
    return null;
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon( // USANDO ÍCONE PLACEHOLDER
                    CupertinoIcons.leaf_arrow_circlepath,
                    size: 80,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'VerdeVivo IA',
                    textAlign: TextAlign.center,
                    style: textTheme.displayLarge?.copyWith(
                      color: primaryColor,
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    'Seu assistente inteligente de jardinagem',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Seu e-mail',
                      prefixIcon: Icon(CupertinoIcons.mail, size: 20), // Ícone Cupertino
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Sua senha',
                      prefixIcon: Icon(CupertinoIcons.lock, size: 20), // Ícone Cupertino
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Por favor, insira sua senha.';
                      return null;
                    },
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Entrar'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text('Não tem uma conta? Cadastre-se'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}