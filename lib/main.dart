//our files
import 'package:instarefine/text_editor.dart';

import 'brightness_editor.dart';
import 'contrast_editor.dart';
import 'filters_editor.dart';
import 'crop_editor.dart';

//flutter packages
import 'dart:developer'; //log()
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:gal/gal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Set the splash screen as the initial screen
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomeScreen after 8 seconds
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 161, 155, 203),
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        backgroundColor: const Color(0xFFB39DD8), // Purple background color
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Navigate to the About screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutScreen(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE8E6F5), // Matches the background color
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png', // Replace with your asset's path
                  width: 400,
                  height: 400,
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (image != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditScreen(imagePath: image.path),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFADD8E6), // Matches the button color
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'LOAD IMAGE',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'An easy-to-use mobile app for Android that allows users to edit, enhance, and manipulate images',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // "InstaRefine" text at the bottom
          Positioned(
            bottom: 48, // Position above the purple bar
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'InstaRefine',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cursive', // Add appropriate font if required
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Purple bar at the very bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 40,
              color: const Color(0xFFB39DD8), // Matches the purple bar color
            ),
          ),
        ],
      ),
    );
  }
}

// About Screen
class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: const Color(0xFFB39DD8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About the App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'InstaRefine is an easy-to-use mobile app for Android that allows users to edit, enhance, and manipulate images. With tools like brightness adjustment, contrast enhancement, filters, and cropping, users can refine their photos with ease.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Developers:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Eisha Rizvi\n• Jacob Rempel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class EditScreen extends StatefulWidget {
  final String imagePath;

  EditScreen({required this.imagePath});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late String imagePath; // To store the current image path
  late File imageFile;   // To store the image file based on the path

  // redo functionality
  late int currentIndex; // To store the current image being displayed
  late List<String> redoStack = [];

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    redoStack.add(widget.imagePath);
    imagePath = widget.imagePath;
    imageFile = File(imagePath); // Initialize the image file based on the path
  }

  // Function to reload the image path when returning from other screens
  void _reloadImage(String newPath) {

    setState(() {
      imagePath = newPath;   // Update the image path with the latest one
      imageFile = File(imagePath); // Reload the image file
    });
  }

  // Function to handle redo / undo updates, should be called after a Navigator.pop()
  void _updateUndo(String newPath) {
    //delete everything after current index
    // if(currentIndex != redoStack.length){
    redoStack.removeRange(currentIndex + 1, redoStack.length);
    // }

    redoStack.add(newPath);
    currentIndex = redoStack.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E6F5),
      appBar: AppBar(
        title: const Text('Edit Image'),
        backgroundColor: const Color(0xFFB39DD8),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () {
              setState(() {
                if((currentIndex - 1) >= 0) {
                  currentIndex--;
                  _reloadImage(redoStack[currentIndex]);
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: () {
              setState(() {
                if((currentIndex + 1) < redoStack.length) {
                  currentIndex++;
                  _reloadImage(redoStack[currentIndex]);
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              // Save Image with try-catch
              try {
                await Gal.putImage(imagePath);
                if(!context.mounted) {return;}
                _showSnackBar(context, "Image saved to gallery");
              } on GalException catch (e) {
                log(e.type.message);
                if(!context.mounted) {return;}
                _showSnackBar(context, e.type.message);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: imageFile.existsSync()
                ? Image.file(imageFile)  // Show the updated image file
                : const Center(child: CircularProgressIndicator()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.brightness_6),
                    onPressed: () async {
                      redoStack.removeRange(currentIndex + 1, redoStack.length); //clears the stack past currentIndex
                      final newPath = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BrightnessScreen(imagePath: imagePath, stackLength: redoStack.length,),
                        ),
                      );
                      if (newPath != null) {
                        _reloadImage(newPath); // Reload image after brightness adjustment
                        _updateUndo(newPath);
                      }
                    },
                  ),
                  const Text("Brightness"),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.contrast),
                    onPressed: () async {
                      redoStack.removeRange(currentIndex + 1, redoStack.length); //clears the stack past currentIndex
                      final newPath = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContrastScreen(imagePath: imagePath, stackLength: redoStack.length),
                        ),
                      );

                      if (newPath != null) {
                        _reloadImage(newPath); // Reload image after contrast adjustment
                        _updateUndo(newPath);
                      }
                    },
                  ),
                  const Text("Contrast"),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter),
                    onPressed: () async {
                      redoStack.removeRange(currentIndex + 1, redoStack.length); //clears the stack past currentIndex
                      final newPath = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilterScreen(imagePath: imagePath, stackLength: redoStack.length,),
                        ),
                      );
                      if (newPath != null) {
                        _reloadImage(newPath); // Reload image after applying filter (e.g., grayscale)
                        _updateUndo(newPath);
                      }
                    },
                  ),
                  const Text("Filter"),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.crop),
                    onPressed: () async {
                      // Implement crop functionality here
                      // Open the cropping screen
                      final croppedImage = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CropScreen(imagePath: imagePath, stackLength: redoStack.length,),
                        ),
                      );
                      if (croppedImage != null) {
                        _reloadImage(croppedImage); // Reload the cropped image
                        _updateUndo(croppedImage);
                      }
                    },
                  ),
                  const Text("Crop"),
                  ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.text_fields),
                    onPressed: () async {
                      // Implement crop functionality here
                      // Open the cropping screen
                      final croppedImage = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TextScreen(imagePath: imagePath, stackLength: redoStack.length,),
                        ),
                      );
                      if (croppedImage != null) {
                        _reloadImage(croppedImage); // Reload the cropped image
                        _updateUndo(croppedImage);
                      }
                    },
                  ),
                  Text("Text"),
                ],
              ),

            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context) // show snack bar
        .showSnackBar(SnackBar(content: Text(message)));
  }
}