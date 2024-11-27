import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BrightnessEditor extends StatefulWidget {
  final String imagePath;

  const BrightnessEditor({super.key, required this.imagePath});

  @override
  _BrightnessEditorState createState() => _BrightnessEditorState();
}

class _BrightnessEditorState extends State<BrightnessEditor> {
  double _brightness = 0.0;
  File? _processedImage;

  Future<void> _adjustBrightness() async {
    try {
      final imageBytes = await File(widget.imagePath).readAsBytes();

      final response = await http.post(
        Uri.parse('YOUR_API_URL_HERE/adjustBrightness'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': base64Encode(imageBytes),
          'brightness': _brightness,
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final processedImagePath = result['imagePath'];
        setState(() {
          _processedImage = File(processedImagePath);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adjusting brightness: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Brightness Adjust"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _processedImage == null
              ? Image.file(File(widget.imagePath), height: 300)
              : Image.file(_processedImage!, height: 300),
          const SizedBox(height: 20),
          const Text('Brightness', style: TextStyle(fontSize: 18)),
          Slider(
            min: -100,
            max: 100,
            value: _brightness,
            onChanged: (value) {
              setState(() {
                _brightness = value;
              });
              _adjustBrightness(); // Adjust brightness on slider change
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.purple, // Purple bar at the bottom
        child: Center(
          child: Text(
            'InstaRefine',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
