import 'package:get/get.dart';
import 'package:hci_group1/models/sports_expert.dart';

class HomeController extends GetxController {
  List<SportsExpert> home_sports_experts = [
    SportsExpert(name: 'Squat', image: 'squat'),
    SportsExpert(name: 'Shoulder Press', image: ''),
    SportsExpert(name: 'Push up', image: ''),
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }
}