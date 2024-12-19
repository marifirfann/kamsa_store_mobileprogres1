import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isAdmin = false.obs; // RxBool to track if the user is an admin

  // Register user
  Future<String> registerUser({
    required String email,
    required String password,
    required String name,
    required String address,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user info in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'address': address,
        'createdAt': DateTime.now(),
      });

      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An unknown error occurred';
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  // Login user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if email is admin@example.com
      if (email == 'admin@example.com') {
        isAdmin.value = true; // Set isAdmin to true for admin
        return 'admin';
      }

      isAdmin.value = false; // Set isAdmin to false for regular users
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Invalid email or password';
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  // Logout user
  Future<void> logoutUser() async {
    await _auth.signOut();
    isAdmin.value = false; // Reset isAdmin when logging out
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
