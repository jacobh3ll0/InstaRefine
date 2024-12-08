// Import Statements
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class ContrastScreen extends StatefulWidget {
  final String imagePath;
  final int stackLength;

  ContrastScreen({required this.imagePath, required this.stackLength});

  @override
  _ContrastScreenState createState() => _ContrastScreenState();
}

class _ContrastScreenState extends State<ContrastScreen> {
  late img.Image originalImage;
  img.Image? editedImage;
  double contrastValue = 1.0; // Default value for no contrast change
  Timer? debounceTimer;

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

  /// Adjust the contrast of the image
  img.Image _adjustContrast(img.Image image, double contrastFactor) {
    final adjustedImage = img.Image.from(image);
    for (int y = 0; y < adjustedImage.height; y++) {
      for (int x = 0; x < adjustedImage.width; x++) {
        final pixel = adjustedImage.getPixel(x, y);

        // Extract RGB channels
        final r = img.getRed(pixel);
        final g = img.getGreen(pixel);
        final b = img.getBlue(pixel);

        // Apply contrast formula
        final newR = ((r - 128) * contrastFactor + 128).clamp(0, 255).toInt();
        final newG = ((g - 128) * contrastFactor + 128).clamp(0, 255).toInt();
        final newB = ((b - 128) * contrastFactor + 128).clamp(0, 255).toInt();

        // Set new pixel with adjusted contrast
        adjustedImage.setPixel(x, y, img.getColor(newR, newG, newB));
      }
    }
    return adjustedImage;
  }

  /// Save the modified image to a temporary file
  Future<void> _saveImage() async {
    if (editedImage == null) return;

    final directory = await getTemporaryDirectory();
    final newPath = '${directory.path}/edited_image${widget.stackLength}.png';

    // Save the edited image
    final editedImageBytes = img.encodePng(editedImage!);
    final file = File(newPath);
    imageCache.clear();
    await file.writeAsBytes(editedImageBytes);

    // Return to the previous screen with the new image path
    Navigator.pop(context, newPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E6F5),
      appBar: AppBar(
        title: const Text('Adjust Contrast'),
        backgroundColor: const Color(0xFFB39DD8),
      ),
      body: editedImage == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Image.memory(
                    Uint8List.fromList(img.encodePng(editedImage!)),
                    fit: BoxFit.contain,
                  ),
                ),
                Slider(
                  value: contrastValue,
                  min: 0.5, // Min contrast value
                  max: 2.0, // Max contrast value
                  divisions: 30, //
                  label: "Contrast: ${contrastValue.toStringAsFixed(1)}",
                  onChanged: (value) {
                    setState(() {
                      contrastValue = value; //
                    });

                    // Debounce the image processing
                    debounceTimer?.cancel();
                    debounceTimer = Timer(Duration(milliseconds: 100), () {
                      setState(() {
                        editedImage = _adjustContrast(originalImage, contrastValue);
                      });
                    });
                  },
                ),
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
              ],
            ),
    );
  }
}
