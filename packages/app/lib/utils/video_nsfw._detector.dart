// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:goramp/utils/index.dart';
// import 'package:tflite/tflite.dart';
// import 'package:video_trimmer/video_trimmer.dart';
// import 'package:image/image.dart' as img;

// const _kInputWidth = 244;
// const _kInputHeight = 244;

// class NSFWRecogntion extends Equatable {
//   final int index;
//   final String label;
//   final double confidence;

//   NSFWRecogntion(this.index, this.label, this.confidence);

//   List<Object> get props => [index, label, confidence];

//   @override
//   String toString() {
//     return '$runtimeType('
//         'index: $index, '
//         'label: $label, '
//         'confidence: $confidence, ';
//   }

//   factory NSFWRecogntion.fromMap(Map<String, dynamic> map) {
//     return NSFWRecogntion(map['index'], map['label'], map['confidence']);
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'index': index,
//       'label': label,
//       'confidence': confidence,
//     };
//   }
// }

// class VideoNSFWDetector {
//   static Future<bool> isNSWF(String modelFile, String labelText,
//       String videoFile, Duration duration, Map<String, double> confidence,
//       {Size videoSize = const Size(224.0, 224.0)}) async {
//     if (modelFile == null) {
//       return null;
//     }
//     if (labelText == null) {
//       return null;
//     }
//     final file = File(modelFile);
//     print('FILE SIZE: ${await file.length()}');
//     print('isRemoteModelDowloaded: $modelFile');
//     print('lableText: $labelText');
//     List<NSFWRecogntion> recoginitions = await detect(
//         modelFile, labelText, videoFile, duration,
//         videoSize: videoSize);
//     if (recoginitions == null) {
//       return false;
//     }
//     recoginitions = recoginitions.where((recognition) {
//       return confidence[recognition.label] != null &&
//           recognition.confidence >= confidence[recognition.label];
//     }).toList();
//     print("recoginitions: $recoginitions");
//     return recoginitions.length > 0;
//   }

//   static Future<List<NSFWRecogntion>> detect(
//       String modelFile, String labels, String videoFile, Duration duration,
//       {Size videoSize = const Size(224.0, 224.0)}) async {
//     try {
//       print("labels:$labels");
//       print("modelFile:$modelFile");
//       await Tflite.loadModel(
//         model: modelFile,
//         labels: labels,
//         isModelAsset: false,
//         isLabelAsset: false,
//       );
//       int seconds = duration.inSeconds;
//       List<VideoThumbnail> thumbs = await VideoTrimmer.extractThumbnails(
//           videoFile, videoSize, seconds,
//           start: 0, end: duration.inMilliseconds);
//       final recognitions = [];

//       for (int i = 0; i < thumbs.length; ++i) {
//         final thumb = thumbs[i];
//         print(
//             "processing thumb $i of ${thumbs.length} dimension: ${thumb.width}x${thumb.height}");
//         img.Image image = img.decodeImage(thumb.data);
//         if (thumb.width != _kInputWidth || thumb.height != _kInputHeight) {
//           image =
//               img.copyResize(image, height: _kInputHeight, width: _kInputWidth);
//           // print(
//           //     "processing thumb $count of ${thumbs.length} dimension: ${thumbs[0].width}x${thumbs[0].height}");
//           // Directory extDir = await getApplicationDocumentsDirectory();
//           // if (UniversalPlatform.isAndroid) {
//           //   extDir = await getExternalStorageDirectory();
//           // }
//           // final dirPath = '${extDir.path}/gotok/images';
//           // await Directory(dirPath).create(recursive: true);
//           // final outputFile = '$dirPath/nswf_test_$i.png';
//           // File f = File(outputFile);
//           // await f.writeAsBytes(img.encodePng(image), flush: true);
//           // print('written to files: $outputFile');
//         }
//         List<dynamic> recognition = await Tflite.runModelOnBinary(
//           binary: _imageToByteListFloat32(image, 224, 0, 255),
//           numResults: 5,
//           threshold: 0.05,
//         );
//         recognitions.add(recognition[0]);
//       }
//       return recognitions
//           .map((dynamic e) => NSFWRecogntion.fromMap(asStringKeyedMap(e)))
//           .toList();
//     } catch (error, stack) {
//       print('error: $error');
//       print('stack: $stack');
//       return null;
//     } finally {
//       Tflite.close();
//     }
//   }

//   static Uint8List _imageToByteListFloat32(
//       img.Image image, int inputSize, double mean, double std) {
//     var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
//     var buffer = Float32List.view(convertedBytes.buffer);
//     int pixelIndex = 0;
//     for (var i = 0; i < inputSize; i++) {
//       for (var j = 0; j < inputSize; j++) {
//         var pixel = image.getPixel(j, i);
//         buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
//         buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
//         buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
//       }
//     }
//     return convertedBytes.buffer.asUint8List();
//   }
// }
