import 'package:get/get.dart';

import '../controllers/katalog_admin_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KatalogAdminController>(
      () => KatalogAdminController(),
    );
  }
}
