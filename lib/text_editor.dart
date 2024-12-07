//flutter packages
import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class TextScreen extends StatefulWidget {
  final String imagePath;
  final int stackLength;

  TextScreen({required this.imagePath, required this.stackLength});

  @override
  _TextScreenState createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  late String imagePath; // To store the current image path
  late File imageFile;   // To store the image file based on the path
  img.Image? editedImage;
  late img.Image originalImage;

  final TextEditingController _controller = TextEditingController();

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
        title: const Text('Text Tool'),
        backgroundColor: const Color(0xFFB39DD8),
      ),
      body: _buildImage()
    );
  }


Widget _buildImage() {
    return editedImage == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView( //avoids keyboard overflowing
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(
              Uint8List.fromList(img.encodePng(editedImage!)),
              fit: BoxFit.contain,
            ),
            _buildTextbox(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _saveImage,
                child: const Text("Save and Return"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFADD8E6),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ]
              ),
        );
  }

  Widget _buildTextbox() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter text here',
            ),
          ),
          SizedBox(height: 16), // Adds some spacing
          ElevatedButton(
            onPressed: _saveText,
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _saveText() {

    int x = 0;
    int y = 0;
    String text = _controller.text;

    setState(() {
      img.drawString(editedImage!, img.arial_48, x, y, text);
    });
  }

}