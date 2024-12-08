# Android Image Editor - “InstaRefine”
<img width="197" alt="Screenshot 2024-12-07 at 10 39 08 PM" src="https://github.com/user-attachments/assets/859b4ccf-576a-437a-8dc5-f9b079719d62">



**InstaRefine** is a mobile image editing application developed for Android that allows users to enhance and manipulate their images using various tools like brightness adjustment, contrast enhancement, filters (including grayscale, sepia, and more), and image cropping. It provides a simple and intuitive interface for users to refine their images quickly and efficiently.


## Developers
- Eisha Rizvi (100782325) - eisha.rizvi@ontariotechu.net
- Jacob Rempel (100823181) - jacob.rempel@ontariotechu.net

## Features

- **Load Images**: Users can load images from their gallery to start editing.
- **Brightness Adjustment**: Modify the brightness of the image for better clarity.
- **Contrast Enhancement**: Adjust the contrast of the image to make the details pop.
- **Filters**: Apply various filters, including grayscale, sepia, and more, to enhance the photo.
- **Cropping**: Crop the image to focus on specific parts or resize it as needed.
- **Undo/Redo**: Easily undo or redo any changes made during the editing process.
- **Save Image**: Save the edited image back to the gallery.

<img width="360" alt="Screenshot 2024-12-07 at 10 31 05 PM" src="https://github.com/user-attachments/assets/ea0bd456-f5e7-4db2-9822-0203ea4841b7">

## Tools and Libraries Used

- **Flutter**: The app is built using the Flutter framework for a smooth and responsive cross-platform experience.
- **Image Picker**: Used to pick images from the gallery for editing.
- **Image Processing Functions**: Custom-built functions for image enhancements such as brightness, contrast, and filters.
- **Dart**: The language used for the logic and backend processing of the app.

## Screens

### Home Screen
The home screen is the entry point of the app, where users can:
- Load images from their gallery.
- View a brief description of the app and its functionalities.
- Navigate to the "About" page from the top-right corner.

<img width="362" alt="Screenshot 2024-12-07 at 10 31 26 PM" src="https://github.com/user-attachments/assets/3e240753-bfe4-4fd8-b95c-91bdbeb794b3">


### Edit Screen
Once an image is loaded, users are taken to the Edit screen, where they can:
- Apply filters (e.g., grayscale, sepia, etc.).
- Adjust brightness and contrast.
- Crop the image.
- Undo/redo changes made during the editing process.

<img width="364" alt="Screenshot 2024-12-07 at 10 31 52 PM" src="https://github.com/user-attachments/assets/5a45d410-efa7-41a9-8136-b4f63db8794f">


### About Screen
The "About" page, accessible from the home screen, provides information about:
- The purpose of the app.
- A brief description of the tools available.
- The developers: Eisha Rizvi and Jacob Rempel.

<img width="361" alt="Screenshot 2024-12-07 at 10 32 15 PM" src="https://github.com/user-attachments/assets/22677ba6-f998-40f8-afde-6727149a050c">


## Installation

To install and run this project locally, follow these steps:

1. Make sure you have Flutter installed and set up on your machine. If not, follow the instructions on the official Flutter website to set up Flutter.

2. Open Android Studio, and navigate to Virtual Device Manager. Start Medium Phone API 35.

3. Clone this repository:
   ```bash
   git clone https://github.com/jacobh3ll0/InstaRefine
   ```
   
4. Go to VS Code and navigate to the project directory:
   ```bash
   cd InstaRefine
   ```
   
5. Install the dependencies:
   ```bash
   flutter clean && flutter pub get && flutter build apk && flutter install
   ```

6. Run the app:
   ```bash
   flutter run
   ```
