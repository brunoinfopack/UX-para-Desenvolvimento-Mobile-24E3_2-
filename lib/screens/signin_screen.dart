import 'package:auto_control_panel/providers/auth_provider.dart';
import 'package:auto_control_panel/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = context.watch<AuthProvider>();
    String? message = authProvider.message;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 30),
                _buildSigninButton(authProvider),
                if (message != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 20),
                _buildSignupRedirect(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para o campo de email
  Widget _buildEmailField() {
    return TextFormField(
      key: const Key('TextFormFieldSigninEmail'),
      onChanged: (value) => email = value,
      decoration: InputDecoration(
        icon: const Icon(Icons.email),
        hintText: 'Informe seu email',
        labelText: 'Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty || !value.contains('@')) {
          return 'Informe um email válido!';
        }
        return null;
      },
    );
  }

  // Método para o campo de senha
  Widget _buildPasswordField() {
    return TextFormField(
      key: const Key('TextFormFieldSigninSenha'),
      obscureText: true,
      onChanged: (value) => password = value,
      decoration: InputDecoration(
        icon: const Icon(Icons.lock),
        hintText: 'Informe sua senha',
        labelText: 'Senha',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          return 'Informe uma senha válida com pelo menos 6 caracteres!';
        }
        return null;
      },
    );
  }

  // Método para o botão de login
  Widget _buildSigninButton(AuthProvider authProvider) {
    return isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });
                authProvider.signIn(email!, password!).then((success) {
                  setState(() {
                    isLoading = false;
                  });
                  if (success) {
                    Navigator.pushReplacementNamed(context, Routes.HOME);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erro ao autenticar o usuário!'),
                      ),
                    );
                  }
                });
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Acessar",
              style: TextStyle(fontSize: 16),
            ),
          );
  }

  // Método para redirecionar para a tela de cadastro
  Widget _buildSignupRedirect() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, Routes.SIGNUP);
      },
      child: const Text(
        "Ainda não tenho cadastro!",
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }
}
