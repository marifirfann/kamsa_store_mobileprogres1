import 'package:get/get.dart';

class KatalogController extends GetxController {
  // Sample list of products
  var products = [
    {
      'title': 'Beras Sehat',
      'description': 'Dengan Beras Sehat, nikmati makanan pokok yang tidak hanya lezat, tetapi juga mendukung pola hidup sehat.',
      'price': 'Rp.20.000/kg',
      'image': 'assets/img/product/BERASSEHAT.png',  // Corrected path
    },
    {
      'title': 'Pakan Ternak',
      'description': 'Pakan Ternak Silase adalah solusi praktis dan efisien untuk memastikan ternak mendapatkan asupan gizi optimal.',
      'price': 'Rp.2000/kg',
      'image': 'assets/img/product/silase.PNG',  // Corrected path
    },
    {
      'title': 'Pupuk Cair',
      'description': 'Dengan Pupuk Cair Urin Kambing, jadikan tanaman Anda lebih subur, hijau, dan sehat secara alami!',
      'price': 'Rp.20.000/Liter',
      'image': 'assets/img/product/PUPUK CAIR BIOPESTISIDA URIN KAMBING.png',  // Corrected path
    },
    {
      'title': 'Pupuk Cair',
      'description': 'Dengan Pupuk Cair Urin Kambing, jadikan tanaman Anda lebih subur, hijau, dan sehat secara alami!',
      'price': 'Rp.20.000/Liter',
      'image': 'assets/img/product/PUPUK CAIR BIOPESTISIDA URIN KAMBING.png',  // Corrected path
    },
    {
      'title': 'Pakan Ternak',
      'description': 'Pakan Ternak Silase adalah solusi praktis dan efisien untuk memastikan ternak mendapatkan asupan gizi optimal.',
      'price': 'Rp.2000/kg',
      'image': 'assets/img/product/silase.PNG',  // Corrected path
    },
    // Add more products as needed
  ].obs;  // Making the list observable using Rx
}
