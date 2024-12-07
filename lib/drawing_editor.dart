//flutter packages
import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class DrawScreen extends StatefulWidget {
  final String imagePath;
  final int stackLength;

  DrawScreen({required this.imagePath, required this.stackLength});

  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  late String imagePath; // To store the current image path
  late File imageFile;   // To store the image file based on the path
  img.Image? editedImage;
  late img.Image originalImage;
  Timer? drawTimer;

  @override
  void initState() {
    super.initState();
    _loadImage();
}

  /// Load the image using the `image` package
  Future<void> _loadImage() async {
    final imageBytes = await File(widget.imagePath).readAsBytes();
    setState(() {
      originalImage = img.decodeImage(imageBytes)!;
      editedImage = originalImage.clone();
    });
  }

  /// Save the modified image to a temporary file
  Future<void> _saveImage() async {
    if (editedImage == null) return;

    final directory = await getTemporaryDirectory();
    final newPath = '${directory.path}/edited_image${widget.stackLength}.png';

    // Save the edited image
    final editedImageBytes = img.encodePng(editedImage!);
    final file = File(newPath);
    imageCache.clear(); //deletes the cached image because file.writeAsBytes won't overwrite it
    await file.writeAsBytes(editedImageBytes);

    // Return to the previous screen with the new image path
    Navigator.pop(context, newPath);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E6F5),
      appBar: AppBar(
        title: const Text('Draw'),
        backgroundColor: const Color(0xFFB39DD8),
      ),
      body: _buildImageDetector2()
    );
  }

  Widget _buildImageDetector2() {
    return editedImage == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
        children: [
          Expanded(
            child: Listener(
              onPointerMove: (PointerMoveEvent event) async {
                // Draw a circle at the pointer location
                final x = event.position.dx.toInt();
                final y = event.position.dy.toInt();
                img.drawCircle(editedImage!, x, y, 20, img.getColor(0, 0, 255)); // Blue color circle

                if (drawTimer != null && drawTimer!.isActive) return;

                drawTimer = Timer(const Duration(milliseconds: 200), () async {
                  setState(() {}); //updates the UI every 50 milliseconds
                });

              },

              child: Image.memory(
                Uint8List.fromList(img.encodePng(editedImage!)),
                // fit: BoxFit.contain,
              ),
            ),
          ),
        ]
            );
  }
  //
  // Widget _buildImageDetector() {
  //   return Listener(
  //     onPointerMove: (PointerMoveEvent event) async {
  //       // Grab the image as a mutable array
  //       final imageBytes = await imageFile.readAsBytes();
  //       final image = img.decodeImage(imageBytes);
  //
  //       if (image == null) {
  //         print("Failed to decode the image.");
  //         return;
  //       }
  //
  //       // Print pointer position
  //       print("Relative position: x:${event.localPosition.dx}, y:${event.localPosition.dy}");
  //
  //       // Draw a circle at the pointer location
  //       final x = event.localPosition.dx.toInt();
  //       final y = event.localPosition.dy.toInt();
  //       img.drawCircle(image, x, y, 20, img.getColor(0, 0, 255)); // Blue color circle
  //
  //       // Update the image file
  //       final updatedImageBytes = img.encodePng(image);
  //       await imageFile.writeAsBytes(updatedImageBytes);
  //
  //       // Trigger a rebuild to show updated image
  //       setState(() {});
  //     },
  //     child: Image.file(imageFile),
  //   );
  // }


}