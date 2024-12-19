import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamsa_store/app/modules/profile/controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileView({super.key});

  // Function to show the profile edit modal
  // Function to show the profile edit modal
  void _showEditProfileModal(BuildContext context) {
    final TextEditingController usernameController =
        TextEditingController(text: controller.userName.value);
    final TextEditingController emailController =
        TextEditingController(text: controller.userEmail.value);
    final TextEditingController passwordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          // Make the modal scrollable
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Implement image picker logic here
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                          controller.userImage.value.isNotEmpty
                              ? controller.userImage.value
                              : 'assets/default_avatar.png'),
                      child:
                          Icon(Icons.camera_alt, size: 30, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Username Input
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // Email Input
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // Password Input (optional)
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // Save Profile Button
                ElevatedButton(
                  onPressed: () {
                    controller.updateProfile(
                      usernameController.text.isNotEmpty
                          ? usernameController.text
                          : controller.userName.value,
                      emailController.text.isNotEmpty
                          ? emailController.text
                          : controller.userEmail.value,
                      passwordController.text.isNotEmpty
                          ? passwordController.text
                          : '',
                    );
                    Get.back(); // Close the modal after update
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF222222), // Black background for button
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Save Profile',
                    style:
                        TextStyle(color: Colors.white), // Make text color white
                  ),
                ),
                const SizedBox(height: 20),
                // Delete Account Button
                ElevatedButton(
                  onPressed: () {
                    controller.deleteAccount();
                    Get.back(); // Close the modal after account deletion
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Red background for delete button
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Delete Account',
                    style:
                        TextStyle(color: Colors.white), // Make text color white
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch user data when the profile page is first opened
    controller.fetchUserData();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/img/kamsa/LOGO.png',
              height: 40,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Obx(() => Text(
                      'Welcome, ${controller.userName.value}!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white, // Default avatar color
                backgroundImage: AssetImage(
                    controller.userImage.value.isNotEmpty
                        ? controller.userImage.value
                        : 'assets/default_avatar.png'),
                child: controller.userImage.value.isEmpty
                    ? Icon(Icons.person, size: 40, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
                  controller.userName.value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(height: 10),
            Obx(() => Text(
                  controller.userEmail.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF222222),
                  ),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showEditProfileModal(context); // Show edit profile modal
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color(0xFF222222), // Black background for button
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Edit Profile',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.logout(); // Call the logout function
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red background for logout button
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child:
                  const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
