// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:opencv_dart/opencv.dart' as cv;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var images = <Uint8List>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<(cv.Mat, cv.Mat)> heavyTaskAsync(cv.Mat im, {int count = 1000}) async {
    late cv.Mat gray, blur;
    for (var i = 0; i < count; i++) {
      gray = await cv.cvtColorAsync(im, cv.COLOR_BGR2GRAY);
      blur = await cv.gaussianBlurAsync(im, (7, 7), 2, sigmaY: 2);
      if (i != count - 1) {
        gray.dispose(); // manually dispose
        blur.dispose(); // manually dispose
      }
    }
    return (gray, blur);
  }

  Future<cv.Mat> adjustBrightness(cv.Mat im) async {
    // Convert Mat to a 3D list for color images
    // List<List<num>> pixelData = im.toList();
    Uint8List pixelData = im.data;

    int rows = im.rows;
    int cols = im.cols;
    int channels = im.channels;

    log(im.type.toString());

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        int index = (i * cols + j) * channels;

        int blue = pixelData[index]; //stored as BGR
        int green = pixelData[index + 1];
        int red = pixelData[index + 2];
        // log('Pixel [$i, $j]: B=$blue, G=$green, R=$red');

        pixelData[index] = (pixelData[index] + 50).clamp(0, 255);
        pixelData[index + 1] = (pixelData[index + 1] + 50).clamp(0, 255);
        pixelData[index + 2] = (pixelData[index + 2] + 50).clamp(0, 255);

        // log(pixelData[i][j].toString(),);
        // pixelData[i][j] = (pixelData[i][j] + 50).clamp(0, 255);
      }
      // log("---------");
    }
    return cv.Mat.fromList(rows, cols, im.type, pixelData);

    // cv.Mat.from3DList(data, im.type);

    log("done brightening");

    // cv.Mat.from(pixelData.iterator, );

    // for (int i = 0; i < rows; i++) {
    //   for (int j = 0; j < cols; j++) {
    //     for (int c = 0; c < 3; c++) { // Assuming 3 channels (BGR or RGB)
    //       pixelData[i][j][c] = (pixelData[i][j][c] + 50).clamp(0, 255);
    //     }
    //   }
    // }

    // Re-create the Mat from the adjusted pixel data
    // cv.Mat brightenedImage = await cv.Mat.fromList(pixelData, im.type());
    //
    // return brightenedImage;
  }

  Future<cv.Mat> resizeImage(cv.Mat im) async {

    // Define the target size
    int newWidth = 10;
    int newHeight = 10;

    var resized = cv.resize(im, (newWidth, newHeight));

    log('Image resized to $newWidth x $newHeight');
    return resized;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final img = await picker.pickImage(
                      source: ImageSource.gallery);
                  if (img != null) {
                    final path = img.path;
                    final mat = cv.imread(path);
                    print("cv.imread: width: ${mat.cols}, height: ${mat
                        .rows}, path: $path");
                    debugPrint("mat.data.length: ${mat.data.length}");
                    // heavy computation
                    final (gray, blur) = await heavyTaskAsync(mat, count: 1);
                    cv.Mat result = cv.Mat.fromMat(mat, copy: true);
                    // result = await resizeImage(result);
                    log("brightening");

                    //create a copy before passing
                    cv.Mat bright = cv.Mat.fromMat(result, copy: true);
                    bright = await adjustBrightness(bright);

                    setState(() {
                      images = [
                        cv.imencode(".png", mat).$2,
                        cv.imencode(".png", gray).$2,
                        cv.imencode(".png", blur).$2,
                        // cv.imencode(".png", cv.resize(result, (300, 300), interpolation: cv.INTER_NEAREST)).$2,
                        cv.imencode(".png", result).$2,
                        // cv.imencode(".png", cv.resize(bright, (300, 300), interpolation: cv.INTER_NEAREST)).$2,
                        cv.imencode(".png", bright).$2,
                      ];
                    });
                  }
                },
                child: const Text("Pick Image"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final data = await DefaultAssetBundle.of(context).load(
                      "images/lenna.png");
                  final bytes = data.buffer.asUint8List();
                  // heavy computation
                  // final (gray, blur) = await heavyTask(bytes);
                  // setState(() {
                  //   images = [bytes, gray, blur];
                  // });
                  final (gray, blur) = await heavyTaskAsync(
                      cv.imdecode(bytes, cv.IMREAD_COLOR));
                  setState(() {
                    images = [bytes, cv
                        .imencode(".png", gray)
                        .$2, cv
                        .imencode(".png", blur)
                        .$2
                    ];
                  });
                },
                child: const Text("Process"),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: images.length,
                        itemBuilder: (ctx, idx) =>
                            Card(
                              child: Image.memory(images[idx]),
                            ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text("test"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

