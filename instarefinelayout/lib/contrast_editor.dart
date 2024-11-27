import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContrastEditor extends StatefulWidget {
  final String imagePath;

  const ContrastEditor({super.key, required this.imagePath});

  @override
  _ContrastEditorState createState() => _ContrastEditorState();
}

class _ContrastEditorState extends State<ContrastEditor> {
  double _contrast = 1.0; // Initial contrast value
  File? _processedImage;

  Future<void> _adjustContrast() async {
    try {
      final imageBytes = await File(widget.imagePath).readAsBytes();

      final response = await http.post(
        Uri.parse('YOUR_API_URL_HERE/adjustContrast'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': base64Encode(imageBytes),
          'contrast': _contrast,
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
      print('Error adjusting contrast: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contrast Adjust"),
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
          const Text('Contrast', style: TextStyle(fontSize: 18)),
          Slider(
            min: 0.0,
            max: 2.0,
            value: _contrast,
            onChanged: (value) {
              setState(() {
                _contrast = value;
              });
              _adjustContrast(); // Adjust contrast on slider change
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
