import 'dart:io';
import 'package:auto_control_panel/providers/auth_provider.dart';
import 'package:auto_control_panel/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? imagePath;
  String? email;
  String? password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = context.watch<AuthProvider>();
    String? message = authProvider.message;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
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
                _buildProfileImagePicker(),
                const SizedBox(height: 20),
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 30),
                _buildSignupButton(authProvider),
                if (message != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para o campo de seleção de imagem de perfil
  Widget _buildProfileImagePicker() {
    return GestureDetector(
      onTap: () async {
        Object? result =
            await Navigator.of(context).pushNamed(Routes.SIGNUPPICTURE);
        if (result != null) {
          setState(() {
            imagePath = result as String;
          });
        }
      },
      child: CircleAvatar(
        radius: 60,
        backgroundImage: imagePath != null ? FileImage(File(imagePath!)) : null,
        child: imagePath == null
            ? const Icon(Icons.camera_alt, size: 40)
            : null,
      ),
    );
  }

  // Método para o campo de email
  Widget _buildEmailField() {
    return TextFormField(
      onChanged: (value) => email = value,
      decoration: InputDecoration(
        icon: const Icon(Icons.email),
        hintText: 'Informe o email para cadastro',
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
      obscureText: true,
      onChanged: (value) => password = value,
      decoration: InputDecoration(
        icon: const Icon(Icons.lock),
        hintText: 'Informe uma senha para cadastro',
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

  // Método para o botão de cadastro
  Widget _buildSignupButton(AuthProvider authProvider) {
    return isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });
                authProvider.signUp(email!, password!).then((success) {
                  setState(() {
                    isLoading = false;
                  });
                  if (success) {
                    Navigator.pushReplacementNamed(context, Routes.HOME);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(authProvider.message ?? 'Erro ao cadastrar'),
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
              "Cadastrar",
              style: TextStyle(fontSize: 16),
            ),
          );
  }
}
