import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class FilterScreen extends StatefulWidget {
  final String imagePath;
  final int stackLength;

  FilterScreen({required this.imagePath, required this.stackLength});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late img.Image originalImage;
  img.Image? editedImage;

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
      editedImage = originalImage.clone(); // Start with the original image
    });
  }

  /// Apply grayscale filter
  img.Image _applyGrayscale(img.Image image) {
    final grayscaleImage = img.Image.from(image);
    for (int y = 0; y < grayscaleImage.height; y++) {
      for (int x = 0; x < grayscaleImage.width; x++) {
        final pixel = grayscaleImage.getPixel(x, y);

        // Convert the pixel to grayscale using luminosity formula
        final r = img.getRed(pixel);
        final g = img.getGreen(pixel);
        final b = img.getBlue(pixel);
        final gray = (r * 0.3 + g * 0.59 + b * 0.11).toInt(); // Grayscale formula

        grayscaleImage.setPixel(x, y, img.getColor(gray, gray, gray));
      }
    }
    return grayscaleImage;
  }

  /// Apply sepia filter
  img.Image _applySepia(img.Image image) {
    final sepiaImage = img.Image.from(image);
    for (int y = 0; y < sepiaImage.height; y++) {
      for (int x = 0; x < sepiaImage.width; x++) {
        final pixel = sepiaImage.getPixel(x, y);

        final r = img.getRed(pixel);
        final g = img.getGreen(pixel);
        final b = img.getBlue(pixel);

        // Apply sepia filter
        final tr = (0.393 * r + 0.769 * g + 0.189 * b).clamp(0, 255).toInt();
        final tg = (0.349 * r + 0.686 * g + 0.168 * b).clamp(0, 255).toInt();
        final tb = (0.272 * r + 0.534 * g + 0.131 * b).clamp(0, 255).toInt();

        sepiaImage.setPixel(x, y, img.getColor(tr, tg, tb));
      }
    }
    return sepiaImage;
  }

  /// Apply grayscale on top of sepia (or vice versa)
  void _applyFilters(bool isGrayscale, bool isSepia) {
    img.Image currentImage = originalImage.clone(); // Start with the original image

    // Apply filters sequentially based on user choices
    if (isGrayscale) {
      currentImage = _applyGrayscale(currentImage); // Apply grayscale first
    }
    if (isSepia) {
      currentImage = _applySepia(currentImage); // Apply sepia on top of grayscale
    }

    setState(() {
      editedImage = currentImage; // Update the edited image
    });
  }

  /// Save the modified image to a temporary file
  Future<void> _saveImage() async {
    if (editedImage == null) return;

    final directory = await getTemporaryDirectory();
    // final newPath = '${directory.path}/edited_image.png';
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
        title: const Text('Apply Filter'),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            editedImage = _applyGrayscale(originalImage);
                          });
                        },
                        child: const Text("Grayscale"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFADD8E6),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            editedImage = _applySepia(originalImage);
                          });
                        },
                        child: const Text("Sepia"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFADD8E6),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Apply both grayscale and sepia
                          _applyFilters(true, true);  // Grayscale on top of Sepia
                        },
                        child: const Text("Grayscale + Sepia"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFADD8E6),
                        ),
                      ),
                    ],
                  ),
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