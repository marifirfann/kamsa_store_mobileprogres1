import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamsa_store/app/modules/auth/controllers/auth_controller.dart';
import 'package:kamsa_store/app/modules/auth/views/login_view.dart';

class ProfileController extends GetxController {
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userImage = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController authController =
      Get.find<AuthController>(); // Use AuthController for logout

  // Fungsi untuk mengambil data pengguna
  void fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        userName.value = userDoc['name'] ?? 'No Name';
        userEmail.value = userDoc['email'] ?? 'No Email';
        userImage.value = userDoc['image'] ?? ''; // Gambar profil, jika ada
      }
    }
  }

  // Fungsi untuk memperbarui profil
  Future<void> updateProfile(String name, String email, String password) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateEmail(email);
        await _firestore.collection('users').doc(user.uid).update({
          'name': name,
          'email': email,
          'image': userImage.value, // Menambahkan perubahan gambar jika ada
        });
        fetchUserData(); // Refresh data setelah update
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green, // Background hijau
          colorText: Colors.white, // Teks putih
          duration: Duration(seconds: 2), // Durasi snackbar
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red, // Background merah untuk error
        colorText: Colors.white, // Teks putih
        duration: Duration(seconds: 2), // Durasi snackbar
      );
    }
  }

  // Fungsi untuk menghapus akun
  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).delete();
        await user.delete(); // Hapus akun pengguna
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Fungsi logout menggunakan AuthController
  void logout() async {
  try {
    await authController.logoutUser(); // Melakukan logout
    // Menampilkan snackbar sukses logout
    Get.snackbar(
      'Success',
      'You have successfully logged out.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
    // Navigasi ke halaman login setelah logout berhasil
    Get.off(LoginView()); // Ganti '/login' dengan rute halaman login sesuai aplikasi kamu
  } catch (e) {
    // Menampilkan snackbar error jika gagal logout
    Get.snackbar(
      'Error',
      'Failed to logout: $e',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }
}

}
