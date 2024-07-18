import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Management App'),
      ),
      body: const Column(
        children: [
          Text('Home'),
          ElevatedButton(onPressed: _logout, child: Text('Logout')),
        ],
      ),
    );
  }

  static void _logout() {
    FirebaseAuth.instance.signOut();
  }
}
