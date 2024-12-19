import 'package:get/get.dart';

import '../controllers/katalog_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KatalogController>(
      () => KatalogController(),
    );
  }
}
