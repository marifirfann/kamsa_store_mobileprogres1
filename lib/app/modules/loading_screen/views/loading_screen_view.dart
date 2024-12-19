import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamsa_store/app/modules/auth/views/login_view.dart';
import 'package:kamsa_store/main.dart'; // Pastikan MainPage diimpor dengan benar

class LoadingScreenView extends StatefulWidget {
  @override
  _LoadingScreenViewState createState() => _LoadingScreenViewState();
}

class _LoadingScreenViewState extends State<LoadingScreenView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Membuat AnimationController untuk animasi pop-up
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    // Membuat animasi skala (scale)
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Menunggu 3 detik sebelum pindah ke halaman utama
    Future.delayed(Duration(seconds: 3), () {
      // Setelah 3 detik, ganti halaman ke MainPage
      Get.off(() => LoginView());
    });

    // Memulai animasi
    _controller.forward();
  }

  @override
  void dispose() {
    // Jangan lupa untuk membersihkan controller agar tidak menyebabkan memory leak
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background warna putih
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation, // Menggunakan animasi skala
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menambahkan gambar logo
              Image.asset(
                'assets/img/kamsa/LOGO.png', 
                width: 150, 
                height: 150,
              ),
              SizedBox(height: 20),
              // Indikator loading
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF222222)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
