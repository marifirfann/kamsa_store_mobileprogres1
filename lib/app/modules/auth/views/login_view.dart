import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamsa_store/app/modules/auth/views/register_view.dart';
import 'package:kamsa_store/app/modules/auth/controllers/auth_controller.dart';
import 'package:kamsa_store/main.dart';

class LoginView extends StatelessWidget {
  final AuthController _authController =
      Get.put(AuthController()); // Inisialisasi AuthController

  final TextEditingController _emailController =
      TextEditingController(); // Controller untuk email
  final TextEditingController _passwordController =
      TextEditingController(); // Controller untuk password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Login', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or App Name
                Icon(
                  Icons.lock,
                  size: 100,
                  color: Colors.blueAccent,
                ),
                SizedBox(height: 40),

                // Email Field
                TextField(
                  controller:
                      _emailController, // Gunakan controller untuk mendapatkan input
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Password Field
                TextField(
                  controller:
                      _passwordController, // Gunakan controller untuk mendapatkan input
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Login Button
                ElevatedButton(
                  onPressed: () async {
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();

                    if (email.isNotEmpty && password.isNotEmpty) {
                      String result = await _authController.loginUser(
                        email: email,
                        password: password,
                      );

                      if (result == 'admin') {
                        // Navigasi ke halaman admin
                        Get.off(() =>
                            MainPage(userType: 'admin')); // Pass 'admin' type
                      } else if (result == 'success') {
                        // Navigasi ke halaman utama
                        Get.off(() =>
                            MainPage(userType: 'user')); // Pass 'user' type
                      } else {
                        // Tampilkan pesan error jika login gagal
                        Get.snackbar(
                          'Error',
                          result,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      }
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please fill in all fields',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.orangeAccent,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF222222),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        Get.to(() => RegisterView());
                      },
                      child:
                          Text('Sign Up', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
