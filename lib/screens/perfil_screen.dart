import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../routes.dart';

class PerfilScreen extends StatelessWidget {
  final String userName = "Bruno Rodrigues dos Santos Silva";
  final String userEmail = "bruno@infopack.com.br";
  final String userImage = "assets/profile_placeholder.png"; // Certifique-se de ter uma imagem de placeholder no assets

  PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil do Usuário"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildProfilePicture(userImage),
            const SizedBox(height: 20),
            _buildUserInfo(userName, userEmail),
            const SizedBox(height: 30),
            _buildProfileOptions(context),
          ],
        ),
      ),
    );
  }

  // Método para exibir a foto de perfil do usuário
  Widget _buildProfilePicture(String imagePath) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: AssetImage(imagePath),
    );
  }

  // Método para exibir as informações do usuário
  Widget _buildUserInfo(String name, String email) {
    return Column(
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          email,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // Método para exibir opções de perfil (editar e sair)
  Widget _buildProfileOptions(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, Routes.SIGNIN)
                    .then((value) {});
          },
          icon: const Icon(Icons.logout),
          label: const Text("Sair"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: Colors.redAccent,
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PerfilScreen(),
  ));
}
