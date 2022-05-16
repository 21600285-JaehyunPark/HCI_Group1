import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:hci_group1/controllers/camera_view_controller.dart';
import 'package:hci_group1/controllers/home_controller.dart';

class MainBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CarouselController>(() => CarouselController());
    Get.lazyPut<CameraViewController>(() => CameraViewController());

  }
}