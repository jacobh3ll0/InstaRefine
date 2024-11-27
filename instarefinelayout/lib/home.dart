import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'editor.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _loadImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditorScreen(imagePath: image.path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color to #d1ccd8 (light purple)
      backgroundColor: Color.fromARGB(255, 220, 219, 222), // Light purple background
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
            'assets/logo.png', 
            height: 370, // Adjust the height to make the logo bigger
            width:370, // Optionally set width if needed
            fit: BoxFit.contain, // Keeps the aspect ratio of the logo
            ),
            // App name in the center of the screen
            Text(
              'InstaRefine',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C558B), // Dark blue color for text
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _loadImage(context),
              child: Text('LOAD IMAGE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFBAD3ED), // Light blue button color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'An easy-to-use mobile app for editing, enhancing, and manipulating images.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF2C558B)), // Dark blue text
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Color(0xFFA78FCD), // Faint purple color for the bottom bar
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
