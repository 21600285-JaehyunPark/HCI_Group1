import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hci_group1/controllers/trainee_controller.dart';

class FirstTrainee extends StatelessWidget {
  final traineeController = Get.find<TraineeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)
        ),
        title: const Text('Squat', style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 40, left: 50, right: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container()
            // Container(
            //   height: 260,
            //   width: 230,
            //   child: CarouselSlider(
            //     options: CarouselOptions(
            //         height: 400.0,
            //       onPageChanged: (index, reason) {
            //         traineeController.selectedIndex;
            //       },
            //     ),
            //     items: [1,2,3].map((i) {
            //       return Builder(
            //         builder: (BuildContext context) {
            //           return Container(
            //               width: MediaQuery.of(context).size.width,
            //               margin: const EdgeInsets.symmetric(horizontal: 5.0),
            //               decoration: const BoxDecoration(
            //                   color: Colors.lightBlueAccent
            //               ),
            //               child: Text('page $i', style: const TextStyle(fontSize: 16.0),)
            //           );
            //         },
            //       );
            //     }).toList(),
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: imagesList.map((urlOfItem) {
            //     int index = imagesList.indexOf(urlOfItem);
            //     return Container(
            //       width: 10.0,
            //       height: 10.0,
            //       margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: _currentIndex == index
            //             ? Color.fromRGBO(0, 0, 0, 0.8)
            //             : Color.fromRGBO(0, 0, 0, 0.3),
            //       ),
            //     );
            //   }).toList(),
            // )
          ],
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
