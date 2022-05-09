import 'package:get/get.dart';
import 'package:hci_group1/binding/main_binding.dart';
import 'package:hci_group1/main.dart';
import 'package:hci_group1/pages/home.dart';
import 'package:hci_group1/pages/trainee_page/first_trainee.dart';

part 'app_route.dart';

class AppPages {
  static const INITIAL = Routes.ROUTE;

  static final routes = [
    GetPage(
      name: Routes.ROUTE,
      page: () => Home(),
      binding: MainBindings(),
    ),
    GetPage(
      name: Routes.firstTrainee,
      binding: MainBindings(),
      page: () => FirstTrainee(),
    ),
  ];
}