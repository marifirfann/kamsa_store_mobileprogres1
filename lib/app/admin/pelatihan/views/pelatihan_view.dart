import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pelatihan_controller.dart';

class PelatihanView extends StatelessWidget {
  final PelatihanController controller = Get.put(PelatihanController());

  PelatihanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color of the whole screen
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80, // Reduced height for a smaller app bar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            Image.asset(
              'assets/img/kamsa/LOGO.png',
              height: 40, // Smaller size for the logo
            ),
            // Search bar
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Courses...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Slight shadow for subtle separation
      ),
      body: Obx(() => DefaultTabController(
        length: 3, // Number of filters
        child: Column(
          children: [
            const TabBar(
              labelColor: Color(0xFF222222), // Color of the selected tab's text
              unselectedLabelColor: Color(0xFF222222),
              indicatorColor: Color(0xFF222222),
              tabs: [
                Tab(text: 'Semua'),
                Tab(text: 'Pelatihan'),
                Tab(text: 'Magang'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCourseList(),
                  _buildCourseList(filter: 'Pelatihan'),
                  _buildCourseList(filter: 'Magang'),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildCourseList({String? filter}) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: controller.pelatihanList.length,
      itemBuilder: (context, index) {
        var course = controller.pelatihanList[index];
        if (filter != null && !course['title'].toString().toLowerCase().contains(filter.toLowerCase())) {
          return const SizedBox.shrink();
        }
        return _buildCourseCard(
          context,
          course['title']! as String,
          course['description']! as String,
          course['image']! as String,
        );
      },
    );
  }

  Widget _buildCourseCard(BuildContext context, String title, String description, String imageUrl) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            Image.asset(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Action for starting the course
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF222222), // Change to dark color
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Mulai Kursus',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
