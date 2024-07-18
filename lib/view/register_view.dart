import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_management/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),
                      const Text(
                        'WELCOME\nBACK',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 20),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.person_outlined),
                                labelText: 'Nama',
                              ),
                            ),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.email_outlined),
                                labelText: 'Email',
                              ),
                            ),
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.phone_outlined),
                                labelText: 'Nomor Telepon',
                              ),
                            ),
                            TextField(
                              obscureText: true,
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.lock_outlined),
                                labelText: 'Password',
                              ),
                            ),
                            TextField(
                              obscureText: true,
                              controller: _confirmPasswordController,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.lock_outlined),
                                labelText: 'Konfirmasi Password',
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _register(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: const Text(
                                  'DAFTAR',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _register(BuildContext context) async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String phone = _phoneController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      _showMessage(context, 'Password dan Konfirmasi Password tidak sesuai');
      return;
    }

    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();
      final User? user = auth.currentUser;

      if (user != null) {
        await firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'uid': user.uid,
          'createdAt': DateTime.now().toIso8601String(),
        });
        log('User registered successfully: ${user.uid}');
        _showMessage(context, 'Registrasi berhasil');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeView(accountInfo: user)));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        log('Akun sudah ada untuk email tersebut.');
        _showMessage(context, 'Akun sudah ada untuk email tersebut.');
      } else if (e.code == 'weak-password') {
        log('Password yang diberikan terlalu lemah.');
        _showMessage(context, 'Password yang diberikan terlalu lemah.');
      } else {
        log('Terjadi kesalahan: ${e.message}');
        _showMessage(context, 'Terjadi kesalahan: ${e.message}');
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
