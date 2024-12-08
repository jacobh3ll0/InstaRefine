import 'package:flutter/material.dart';

class ExploreFeaturesScreen extends StatelessWidget {
  const ExploreFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Features'),
        backgroundColor: const Color(0xFFB39DD8),
      ),
      backgroundColor: const Color(0xFFE8E6F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              const Text(
                'Explore Our Image Editing Features',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'InstaRefine offers a range of powerful and easy-to-use image editing tools to help you refine and enhance your photos.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),

              // Feature List
              const FeatureCard(
                icon: Icons.brightness_4,
                title: 'Brightness Adjustment',
                description:
                    'Easily adjust the brightness of your images to make them lighter or darker.',
              ),
              const FeatureCard(
                icon: Icons.settings_overscan,
                title: 'Contrast Adjustment',
                description:
                    'Enhance the difference between light and dark areas to make your image stand out.',
              ),
              const FeatureCard(
                icon: Icons.filter_vintage,
                title: 'Grayscale Filter',
                description:
                    'Convert your image to black and white for a classic, timeless look.',
              ),
              const FeatureCard(
                icon: Icons.palette,
                title: 'Sepia Filter',
                description:
                    'Apply a warm, vintage sepia tone for a nostalgic and artistic effect.',
              ),
              const FeatureCard(
                icon: Icons.crop,
                title: 'Cropping',
                description:
                    'Crop your image to remove unwanted areas and focus on the subject.',
              ),
              const FeatureCard(
                icon: Icons.text_fields,
                title: 'Adding Text',
                description:
                    'Add personalized text to your image to create unique captions or messages.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color(0xFFB39DD8),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
