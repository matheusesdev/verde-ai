// lib/screens/login_screen.dart
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave para o formulário
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu e-mail.';
    }
    // Expressão regular para validar e-mail (simples, mas inclui o @ e um domínio)
    // Exemplo: nome@dominio.com
    // Para uma validação mais robusta, você pode usar pacotes como `email_validator`
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um e-mail válido (ex: nome@dominio.com).';
    }
    return null;
  }

  void _login() {
    // Validar o formulário antes de prosseguir
    if (_formKey.currentState!.validate()) {
      // Simulação de login
      // Aqui você faria a autenticação real
      print('Email: ${_emailController.text}');
      print('Senha: ***'); // Não imprima a senha em produção
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
    return Scaffold(
      body: SafeArea(
        child: Center( // Centralizar o Form
          child: SingleChildScrollView( // Permitir rolagem
            padding: const EdgeInsets.all(24.0),
            child: Form( // Envolver com Form
              key: _formKey, // Associar a chave
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo_verdevivo.png',
                    height: 100,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.eco, size: 100, color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'VerdeVivo IA',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 30),
                  TextFormField( // Alterado de TextField para TextFormField
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail, // Adicionar validador
                  ),
                  const SizedBox(height: 15),
                  TextFormField( // Alterado de TextField para TextFormField
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) { // Validador simples para senha
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Entrar'),
                  ),
                  TextButton(
                    onPressed: () {
                      // MODIFICADO: Navegar para a tela de cadastro
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