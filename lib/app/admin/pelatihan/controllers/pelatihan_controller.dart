import 'package:get/get.dart';

class PelatihanController extends GetxController {
  // Sample list of pelatihan (trainings)
  var pelatihanList = [
    {
      'title': 'Pelatihan Pakan Ternak ',
      'description': 'Pelatihan Pakan Ternak Fermentasi  & Silase Pelajari cara membuat pakan ternak fermentasi dan silase untuk meningkatkan kualitas pakan dan efisiensi biaya.',
      'image': 'assets/img/pelatihan/pelatihan (1).jpg',  // Replace with your image path
    },
    {
      'title': 'Pelatihan Pembuatan Pupuk Organik',
      'description': 'Pelatihan Pembuatan Pupuk Organik Pelatihan pembuatan pupuk organik dari pengolahan limbah ternak untuk meningkatkan kesuburan tanah dan ramah lingkungan.',
      'image': 'assets/img/pelatihan/pelatihan (2).jpg', // Replace with your image path
    },
    {
      'title': 'Pelatihan Pembuatan Pupuk',
      'description': 'Pelatihan Pembuatan Pupuk Organik Pelatihan pembuatan pupuk organik dari pengolahan limbah ternak untuk meningkatkan kesuburan tanah dan ramah lingkungan.',
      'image': 'assets/img/pelatihan/pelatihan (3).jpg', // Replace with your image path
    },
  ].obs;  // Making the list observable using Rx
}
