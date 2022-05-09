import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hci_group1/controllers/home_controller.dart';

class Home extends StatelessWidget {
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('Pocket Trainer', style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: GridView.builder(
          itemCount: homeController.home_sports_experts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, //1 개의 행에 보여줄 item 개수
              childAspectRatio: 3 / 1, //item 의 가로 1, 세로 2 의 비율
              mainAxisSpacing: 10, //수평 Padding
              crossAxisSpacing: 10, //수직 Padding
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed('/home/firstTrainee');
                },
                child: Card(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: 50,
                        height: 50,
                        color: Colors.blue,
                      ),
                      Expanded(
                          child: Center(child: Text(homeController.home_sports_experts[index].name))
                      )
                    ],
                  ),
                ),
              );
            }
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            label: 'Learn',
            icon: Icon(Icons.directions_run_outlined, size: 20,),
          ),
          BottomNavigationBarItem(
            label: 'Video',
            icon: Icon(Icons.camera_alt_outlined, size: 20,),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person_outline, size: 20,),
          ),
        ],
      ),
    );
  }
}
