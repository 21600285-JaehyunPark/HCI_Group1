import 'package:get/get.dart';
import 'package:hci_group1/controllers/home_controller.dart';

class MainBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<HomeController>(() => HomeController());

  }
}