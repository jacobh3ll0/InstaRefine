import 'package:flutter/material.dart';
import 'package:image_crop_plus/image_crop_plus.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class CropScreen extends StatefulWidget {
  final String imagePath;
  final int stackLength;

  CropScreen({required this.imagePath, required this.stackLength});

  @override
  _CropScreenState createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  late File imageFile;
  late double? aspectRatio = 4.0 / 3.0; //default

  @override
  void initState() {
    super.initState();
    imageFile = File(widget.imagePath);
  }

  final cropKey = GlobalKey<CropState>();


  Widget _buildCropImage() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(20.0),
      child: Crop.file(
        imageFile,
        key: cropKey,
        aspectRatio: aspectRatio,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop'),
        backgroundColor: const Color(0xFFB39DD8),
        actions: [
          ElevatedButton(onPressed: () {
            setState(() {
              aspectRatio = 4.0 / 3.0;
            });
          }, child: const Text("4:3")),
          ElevatedButton(onPressed: () {
            setState(() {
              aspectRatio = 1.0;
            });
          }, child: const Text("1:1")),
          ElevatedButton(onPressed: () {
            setState(() {
              aspectRatio = null;
            });
          }, child: const Text("Free")),
        ],
      ),
      body: _buildCropImage(),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {_saveImage(context);},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFADD8E6),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Save and Return"),
        ),
      ),
    );
  }

  Future<void> _saveImage(BuildContext context) async {
    final crop = cropKey.currentState;

    // Perform the crop
    final scale = crop?.scale;
    final area = crop?.area;

    if (area == null) {
      // cannot crop, widget is not setup
      Navigator.pop(context);
    }

    final sample = await ImageCrop.sampleImage(
      file: imageFile,
      preferredSize: (2000 / scale!).round(),
    );

    final croppedImage = await ImageCrop.cropImage(
      file: sample,
      area: area!,
    );

    sample.delete();

    // create temp directory for cropped image (also part of undo/redo functionality)
    final directory = await getTemporaryDirectory();
    final newPath = '${directory.path}/edited_image${widget.stackLength}.png';

    // Save the edited image
    final editedImageBytes = await croppedImage.readAsBytes();
    final file = File(newPath);
    imageCache.clear(); // Clears the cached image
    await file.writeAsBytes(editedImageBytes);

    // Return to the previous screen with the new image path
    if(!context.mounted) {return;}
    Navigator.pop(context, newPath);

  }

}