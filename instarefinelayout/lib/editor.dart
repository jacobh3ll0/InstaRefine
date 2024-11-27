import 'dart:io';
import 'package:flutter/material.dart';
import 'brightness_editor.dart';
import 'contrast_editor.dart';
import 'filters_editor.dart';

class EditorScreen extends StatelessWidget {
  final String imagePath;

  const EditorScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Image"),
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
          Image.file(
            File(imagePath),
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.brightness_6),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BrightnessEditor(imagePath: imagePath),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.contrast),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContrastEditor(imagePath: imagePath),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.filter),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FiltersEditor(imagePath: imagePath),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Color(0xFFA78FCD), // Purple bar at the bottom
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
