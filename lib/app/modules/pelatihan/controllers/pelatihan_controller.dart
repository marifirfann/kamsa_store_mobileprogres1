import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PelatihanController extends GetxController {
  RxList pelatihanList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPelatihanData();
  }

  // Fetch data from Firestore
  void fetchPelatihanData() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('pelatihan').get();
    var data = querySnapshot.docs
        .map((doc) => {
              ...doc.data() as Map<String, dynamic>, // Include document ID
              'id': doc.id,
            })
        .toList();

    pelatihanList.assignAll(data);
  }

  // Add new course to Firestore
  void addNewCourse(String title, String description, String imageUrl) {
    FirebaseFirestore.instance.collection('pelatihan').add({
      'title': title,
      'description': description,
      'image': imageUrl,
    });
    fetchPelatihanData();
  }

  // Update existing course
  void updateCourse(
      int index, String title, String description, String imageUrl) {
    var course = pelatihanList[index];
    FirebaseFirestore.instance
        .collection('pelatihan')
        .doc(course['id'])
        .update({
      'title': title,
      'description': description,
      'image': imageUrl,
    });
    fetchPelatihanData();
  }

  // Delete course from Firestore
  void deleteCourse(int index) {
    var course = pelatihanList[index];
    FirebaseFirestore.instance
        .collection('pelatihan')
        .doc(course['id'])
        .delete();
    fetchPelatihanData();
  }
}
