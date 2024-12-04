import 'package:flutter/material.dart';
import 'package:image_cropper_plus/image_cropper_plus.dart';  // Import the correct package
import 'dart:io';

class CropScreen extends StatefulWidget {
  final String imagePath;

  CropScreen({required this.imagePath});

  @override
  _CropScreenState createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  late File imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = File(widget.imagePath);
  }

  Future<void> _cropImage() async {
    final croppedFile = await ImageCropper().cropImage(  // Correct usage of ImageCropper()
      sourcePath: widget.imagePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: false,
          resetAspectRatioEnabled: true,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        imageFile = File(croppedFile.path); // Update the image with the cropped one
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Image'),
        backgroundColor: const Color(0xFFB39DD8),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Implement save functionality here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: imageFile.existsSync()
                ? Image.file(imageFile)  // Show the updated cropped image
                : const Center(child: CircularProgressIndicator()),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _cropImage,
              child: const Text('Crop Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFADD8E6),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
