import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import '../main.dart';
import '../pages/pose_page/pose_painter.dart';

enum ScreenMode { liveFeed, gallery }

class CameraViewController extends GetxController {
  // get from parameter
  String title = 'Pose Detector';
  late CustomPaint? customPaint;
  late String? text;
  CameraLensDirection initialDirection = CameraLensDirection.front;

  // In camera_view
  ScreenMode mode = ScreenMode.liveFeed;
  CameraController? controller;
  File? image;
  String? _path;
  ImagePicker? imagePicker;
  int cameraIndex = 0;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  bool allowPicker = true;
  bool changingCameraLens = false;

  // In pose_detector_view
  final PoseDetector poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool canProcess = true;
  bool isBusy = false;

  String? getPath() {
    return _path;
  }

  var isLoading = true.obs;

  @override
  void onInit() async{
    // TODO: implement onInit
    imagePicker = ImagePicker();

    if (cameras.any(
          (element) =>
      element.lensDirection == initialDirection &&
          element.sensorOrientation == 90,
    )) {
      cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
        element.lensDirection == initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      cameraIndex = cameras.indexOf(
        cameras.firstWhere(
              (element) => element.lensDirection == initialDirection,
        ),
      );
    }

    _startLiveFeed();
    super.onInit();
  }

  @override
  void dispose() {
    canProcess = false;
    poseDetector.close();
    _stopLiveFeed();
    super.dispose();
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!canProcess) return;
    if (isBusy) return;
    isBusy = true;
    text = '';
    update();
    final poses = await poseDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePainter(poses, inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      text = 'Poses found: ${poses.length}\n\n';
      // TODO: set _customPaint to draw landmarks on top of image
    }
    isBusy = false;
    if (Get.routing.current == "/home/firstTrainee/poseDetector") {
      return ;
    }
  }

  Future getImage(ImageSource source) async {
    image = null;
    _path = null;
    final pickedFile = await imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    }
    update();
  }

  void switchScreenMode() {
    image = null;
    if (mode == ScreenMode.liveFeed) {
      mode = ScreenMode.gallery;
      _stopLiveFeed();
    } else {
      mode = ScreenMode.liveFeed;
      _startLiveFeed();
    }
    update();
  }

  Future _startLiveFeed() async {
    final camera = cameras[cameraIndex];
    controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await controller!.initialize().then((_) {
      if (Get.routing.current == "/home/firstTrainee/poseDetector") {
        print("mounting...");
        return;
      }
      controller!.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      }).whenComplete(() => print("getMinZoomLevel done"));
      controller!.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      }).whenComplete(() => print("getMaxZoomLevel done"));
      controller!.startImageStream(_processCameraImage);
      update();
    }).whenComplete(() {
      isLoading.value = false;
      print(mode);
    });

    // controller!.addListener(() {
    //   if (Get.routing.current == "/home/firstTrainee/poseDetector") update();
    //   if (controller!.value.hasError) {
    //     print("'Camera error ${controller!.value.errorDescription}'");
    //   }
    // });

    print("controller: " + controller!.value.toString());
  }

  Future _stopLiveFeed() async {
    await controller?.stopImageStream();
    await controller?.dispose();
    controller = null;
  }

  Future switchLiveCamera() async {
    changingCameraLens = true;
    update();
    cameraIndex = (cameraIndex + 1) % cameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
    changingCameraLens = false;
    update();
  }

  Future _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    image = File(path);
    _path = path;
    final inputImage = InputImage.fromFilePath(path);
    processImage(inputImage);
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
    Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[cameraIndex];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.nv21;

    final planeData = image.planes.map(
          (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
    InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    processImage(inputImage);
  }
}