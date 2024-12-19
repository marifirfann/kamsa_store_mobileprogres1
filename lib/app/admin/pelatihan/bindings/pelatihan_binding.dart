import 'package:get/get.dart';

import '../controllers/pelatihan_controller.dart';

class PelatihanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PelatihanController>(
      () => PelatihanController(),
    );
  }
}
