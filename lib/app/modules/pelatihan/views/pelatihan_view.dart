import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/pelatihan_controller.dart';
import 'package:kamsa_store/app/modules/auth/controllers/auth_controller.dart';

class PelatihanView extends StatelessWidget {
  final PelatihanController controller = Get.put(PelatihanController());
  final AuthController authController = Get.find<AuthController>();

  PelatihanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            if (authController.isAdmin.value)
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _showAddCourseModal(context);
                },
              ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.pelatihanList.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const TabBar(
                labelColor: Color(0xFF222222),
                unselectedLabelColor: Color(0xFF222222),
                indicatorColor: Color(0xFF222222),
                tabs: [
                  Tab(text: 'Semua'),
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
        );
      }),
    );
  }

  Widget _buildCourseList({String? filter}) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: controller.pelatihanList.length,
      itemBuilder: (context, index) {
        var course = controller.pelatihanList[index];
        if (filter != null &&
            !course['title']
                .toString()
                .toLowerCase()
                .contains(filter.toLowerCase())) {
          return const SizedBox.shrink();
        }
        return _buildCourseCard(
          context,
          course['title']! as String,
          course['description']! as String,
          course['image']! as String,
          index,
        );
      },
    );
  }

  Widget _buildCourseCard(BuildContext context, String title,
      String description, String imageUrl, int index) {
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
            Image.network(
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
                      if (authController.isAdmin.value) {
                        _showEditCourseModal(context, index);
                      } else {
                        // Action for starting the course
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF222222),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      authController.isAdmin.value
                          ? 'Edit Kursus'
                          : 'Mulai Kursus',
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

  void _showEditCourseModal(BuildContext context, int index) {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    XFile? _imageFile;

    // Pre-fill the data of the selected course
    _titleController.text = controller.pelatihanList[index]['title']!;
    _descriptionController.text =
        controller.pelatihanList[index]['description']!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit Kursus',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                SizedBox(height: 20),
                _buildTextField(_titleController, 'Nama Kursus'),
                SizedBox(height: 10),
                _buildTextField(_descriptionController, 'Deskripsi Kursus',
                    maxLines: 3),
                SizedBox(height: 10),
                Row(
                  children: [
                    _imageFile == null
                        ? Text('No image selected')
                        : Image.file(File(_imageFile!.path),
                            width: 50, height: 50),
                    IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: () async {
                        final pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          _imageFile = pickedFile;
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_titleController.text.isEmpty ||
                              _descriptionController.text.isEmpty) {
                            Get.snackbar('Error',
                                'Harap lengkapi semua informasi kursus');
                          } else {
                            String imageUrl = controller.pelatihanList[index]
                                ['image'];

                            if (_imageFile != null) {
                              imageUrl = _imageFile!.path;
                            }

                            controller.updateCourse(
                              index,
                              _titleController.text,
                              _descriptionController.text,
                              imageUrl,
                            );

                            Navigator.pop(context);
                            Get.snackbar('Success', 'Kursus berhasil diubah');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white),
                        child: Text('Update'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.deleteCourse(index);
                          Navigator.pop(context);
                          Get.snackbar('Deleted', 'Kursus berhasil dihapus');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white),
                        child: Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddCourseModal(BuildContext context) {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    XFile? _imageFile;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add New Course',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                SizedBox(height: 20),
                _buildTextField(_titleController, 'Course Name'),
                SizedBox(height: 10),
                _buildTextField(_descriptionController, 'Course Description',
                    maxLines: 3),
                SizedBox(height: 10),
                Row(
                  children: [
                    _imageFile == null
                        ? Text('No image selected')
                        : Image.file(File(_imageFile!.path),
                            width: 50, height: 50),
                    IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: () async {
                        final pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          _imageFile = pickedFile;
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_titleController.text.isEmpty ||
                              _descriptionController.text.isEmpty) {
                            Get.snackbar('Error',
                                'Harap lengkapi semua informasi kursus');
                          } else {
                            String imageUrl = '';

                            if (_imageFile != null) {
                              imageUrl = _imageFile!.path;
                            }

                            controller.addNewCourse(
                              _titleController.text,
                              _descriptionController.text,
                              imageUrl,
                            );

                            Navigator.pop(context);
                            Get.snackbar('Success', 'Kursus berhasil ditambahkan');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white),
                        child: Text('Add Course'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int? maxLines, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
