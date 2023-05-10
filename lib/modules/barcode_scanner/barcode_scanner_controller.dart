import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payflow/modules/barcode_scanner/barcode_scanner_status.dart';

class BarcodeScannerController {
  final statusNotifier =
      ValueNotifier<BarcodeScannerStatus>(BarcodeScannerStatus());
  BarcodeScannerStatus get status => statusNotifier.value;
  set status(BarcodeScannerStatus status) => statusNotifier.value = status;

  final BarcodeScanner barcodeScanner = GoogleMlKit.vision.barcodeScanner();

  void getAvailableCamera() async {
    try {
      final response = await availableCameras();
      final camera = response.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.back);
      final CameraController cameraController =
          CameraController(camera, ResolutionPreset.max, enableAudio: false);
      await cameraController.initialize();
      status = BarcodeScannerStatus.available(cameraController);
      scanWithCamera();
    } catch (e) {
      status = BarcodeScannerStatus.error(e.toString());
    }
  }

  void scanWithImagePicker() async {
    await status.cameraController!.stopImageStream();
    final response = await ImagePicker().getImage(source: ImageSource.gallery);
    final inputImage = InputImage.fromFilePath(response!.path);
    scannerBarCode(inputImage);
  }

  void listenCamera() {
    if (status.cameraController!.value.isStreamingImages == false) {
      status.cameraController!.startImageStream((cameraImage) async {
        try {
          final WriteBuffer allBytes = WriteBuffer();
          for (Plane plane in cameraImage.planes) {
            allBytes.putUint8List(plane.bytes);
          }
          final bytes = allBytes.done().buffer.asUint8List();
          final imageSize = Size(
            cameraImage.width.toDouble(),
            cameraImage.height.toDouble(),
          );
          const imageRotation = InputImageRotation.rotation0deg;
          final inputImageFormat =
              InputImageFormatValue.fromRawValue(cameraImage.format.raw) ??
                  InputImageFormat.nv21;
          final planeData = cameraImage.planes.map(
            (plane) {
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

          final inputImageCamera = InputImage.fromBytes(
            bytes: bytes,
            inputImageData: inputImageData,
          );

          await Future.delayed(Duration(seconds: 3));

          scannerBarCode(inputImageCamera);
        } catch (e, s) {
          debugPrint('Error when reading camera ${e.toString()}');
          debugPrint('Stack when reading camera ${s.toString()}');
        }
      });
    }
  }

  Future<void> scannerBarCode(InputImage inputImage) async {
    try {
      if (status.cameraController != null) {
        if (status.cameraController!.value.isStreamingImages) {
          status.cameraController!.stopImageStream();
        }
      }

      final barcodes = await barcodeScanner.processImage(inputImage);
      var barcode;
      for (Barcode item in barcodes) {
        barcode = item.displayValue;
      }

      if (barcode != null && status.barcode.isEmpty) {
        status = BarcodeScannerStatus.barcode(barcode);
        status.cameraController!.dispose();
      } else {
        getAvailableCamera();
      }
    } catch (e) {
      debugPrint('Error when scanning barcode ${e.toString()}');
      debugPrint('Stack when scanning barcode ${e.toString()}');
    }
  }

  void scanWithCamera() {
    Future.delayed(const Duration(seconds: 10)).then((value) {
      if (status.cameraController != null) {
        if (status.cameraController!.value.isStreamingImages) {
          status.cameraController!.stopImageStream();
        }
      }
      status = BarcodeScannerStatus.error('Timeout de leitura de boleto');
    });
    listenCamera();
  }

  void dispose() {
    statusNotifier.dispose();
    barcodeScanner.close();
    if (status.showCamera) {
      status.cameraController!.dispose();
    }
  }
}
