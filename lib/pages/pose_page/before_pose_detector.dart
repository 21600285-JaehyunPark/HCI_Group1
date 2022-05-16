// import 'package:flutter/material.dart';
// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:hci_group1/controllers/camera_view_controller.dart';
// import 'package:hci_group1/pages/pose_page/pose_detector_view.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../main.dart';
//
// class BeforePoseDetector extends StatelessWidget {
//   final cameraViewController = Get.find<CameraViewController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if(cameraViewController.isLoading.value == false) {
//         return PoseDetectorView();
//       } else{
//         return Container();
//       }
//     });
//   }
// }
