import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hci_group1/controllers/camera_view_controller.dart';
import 'package:image_picker/image_picker.dart';
import '../../main.dart';

enum ScreenMode { liveFeed, gallery }

class PoseDetectorView extends StatelessWidget {
  final cameraViewController = Get.find<CameraViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cameraViewController.title, style: TextStyle(color: Colors.black),),
        actions: [
          if (cameraViewController.allowPicker)
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: cameraViewController.switchScreenMode,
                child: Icon(
                  cameraViewController.mode == ScreenMode.liveFeed
                      ? Icons.photo_library_outlined
                      : (Platform.isIOS
                      ? Icons.camera_alt_outlined
                      : Icons.camera),
                ),
              ),
            ),
        ],
      ),
      body: Obx(() {
        if(cameraViewController.isLoading.value == false) {
          return _body();
        } else{
          return Container();
        }
      }),
      // body: _body(),
      floatingActionButton: _floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget? _floatingActionButton() {
    if (cameraViewController.mode == ScreenMode.gallery) return null;
    if (cameras.length == 1) return null;
    return SizedBox(
        height: 70.0,
        width: 70.0,
        child: FloatingActionButton(
          child: Icon(
            Platform.isIOS
                ? Icons.flip_camera_ios_outlined
                : Icons.flip_camera_android_outlined,
            size: 40,
          ),
          onPressed: cameraViewController.switchLiveCamera,
        ));
  }

  Widget _body() {
    Widget body;
    // if (cameraViewController.mode == ScreenMode.liveFeed) {
    //   print("Live Feed Body()");
    //   body = _liveFeedBody();
    // } else {
    //   print("Not Live Feed Body()");
    //   body = _galleryBody();
    // }
    return _liveFeedBody();
  }

  Widget _liveFeedBody() {
    if (cameraViewController.controller?.value.isInitialized == false) {
      print('not initialized');
      return Container();
    }

    final size = Get.mediaQuery.size;
    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * cameraViewController.controller!.value.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Transform.scale(
            scale: scale,
            child: Center(
              child: cameraViewController.changingCameraLens
                  ? Center(
                child: const Text('Changing camera lens'),
              )
                  : CameraPreview(cameraViewController.controller!),
            ),
          ),
          if (cameraViewController.customPaint != null) cameraViewController.customPaint!,
          Positioned(
            bottom: 100,
            left: 50,
            right: 50,
            child: Slider(
              value: cameraViewController.zoomLevel,
              min: cameraViewController.minZoomLevel,
              max: cameraViewController.maxZoomLevel,
              onChanged: (newSliderValue) {
                cameraViewController.zoomLevel = newSliderValue;
                cameraViewController.controller!.setZoomLevel(cameraViewController.zoomLevel);
              },
              divisions: (cameraViewController.maxZoomLevel - 1).toInt() < 1
                  ? null
                  : (cameraViewController.maxZoomLevel - 1).toInt(),
            ),
          )
        ],
      ),
    );
  }

  Widget _galleryBody() {
    return ListView(shrinkWrap: true, children: [
      cameraViewController.image != null
          ? SizedBox(
        height: 400,
        width: 400,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.file(cameraViewController.image!),
            if (cameraViewController.customPaint != null) cameraViewController.customPaint!,
          ],
        ),
      )
          : Icon(
        Icons.image,
        size: 200,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          child: Text('From Gallery'),
          onPressed: () => cameraViewController.getImage(ImageSource.gallery),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          child: Text('Take a picture'),
          onPressed: () => cameraViewController.getImage(ImageSource.camera),
        ),
      ),
      if (cameraViewController.image != null)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
              '${cameraViewController.getPath() == null ? '' : 'Image path: $cameraViewController.path'}\n\n${cameraViewController.text ?? ''}'),
        ),
    ]);
  }
}
