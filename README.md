# Android Image Editor - “InstaRefine”

**InstaRefine** is a mobile image editing application developed for Android that allows users to enhance and manipulate their images using various tools like brightness adjustment, contrast enhancement, filters (including grayscale, sepia, and more), and image cropping. It provides a simple and intuitive interface for users to refine their images quickly and efficiently.

## Developers
Eisha Rizvi (100782325) - eisha.rizvi@ontariotechu.net
Jacob Rempel (100823181) - jacob.rempel@ontariotechu.net

## Features

- **Load Images**: Users can load images from their gallery to start editing.
- **Brightness Adjustment**: Modify the brightness of the image for better clarity.
- **Contrast Enhancement**: Adjust the contrast of the image to make the details pop.
- **Filters**: Apply various filters, including grayscale, sepia, and more, to enhance the photo.
- **Cropping**: Crop the image to focus on specific parts or resize it as needed.
- **Undo/Redo**: Easily undo or redo any changes made during the editing process.
- **Save Image**: Save the edited image back to the gallery.

## Tools and Libraries Used

- **Flutter**: The app is built using the Flutter framework for a smooth and responsive cross-platform experience.
- **Image Picker**: Used to pick images from the gallery for editing.
- **Image Cropper Plus**: Allows users to crop images to specific dimensions (if implemented as part of the project).
- **Image Processing Functions**: Custom-built functions for image enhancements such as brightness, contrast, and filters.
- **Dart**: The language used for the logic and backend processing of the app.

## Screens

### Home Screen
The home screen is the entry point of the app, where users can:
- Load images from their gallery.
- View a brief description of the app and its functionalities.
- Navigate to the "About" page from the top-right corner.

### Edit Screen
Once an image is loaded, users are taken to the Edit screen, where they can:
- Apply filters (e.g., grayscale, sepia, etc.).
- Adjust brightness and contrast.
- Crop the image (if implemented).
- Undo/redo changes made during the editing process.

### About Screen
The "About" page, accessible from the home screen, provides information about:
- The purpose of the app.
- A brief description of the tools available.
- The developers: Eisha Rizvi and Jacob Rempel.

## Installation

To install and run this project locally, follow these steps:

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/insta-refine.git
   ```

2. Navigate to the project directory:
```bash
cd insta-refine
```

4. Install the dependencies:
```bash
flutter pub get
```

6. Run the app:
```bash
flutter run
```

Make sure you have Flutter installed and set up on your machine. If not, follow the instructions on the official Flutter website to set up Flutter.
