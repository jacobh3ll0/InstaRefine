import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FiltersEditor extends StatefulWidget {
  final String imagePath;

  const FiltersEditor({super.key, required this.imagePath});

  @override
  _FiltersEditorState createState() => _FiltersEditorState();
}

class _FiltersEditorState extends State<FiltersEditor> {
  File? _processedImage;

  Future<void> _applyFilter(String filterType) async {
    try {
      final imageBytes = await File(widget.imagePath).readAsBytes();

      final response = await http.post(
        Uri.parse('YOUR_API_URL_HERE/applyFilter'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': base64Encode(imageBytes),
          'filter': filterType,
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
      print('Error applying filter: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filters"),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _applyFilter('grayscale'),
                child: const Text('Grayscale'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _applyFilter('sepia'),
                child: const Text('Sepia'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _applyFilter('blur'),
                child: const Text('Blur'),
              ),
            ],
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
