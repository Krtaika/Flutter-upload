import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'design_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ImageUploadScreen extends StatelessWidget {
  ImageUploadScreen({Key? key}) : super(key: key); // Constructor with key

  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Room Image')), // Regular Text
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              Provider.of<DesignProvider>(context, listen: false).uploadImage(image.path);
              await uploadImageToFirebase(image.path);
              if (context.mounted) { // Check if the context is mounted
                await Provider.of<DesignProvider>(context, listen: false).processImage(image.path);
                Navigator.pushNamed(context, '/options');
              }
            }
          },
          child: Text('Select Image'), // Regular Text
        ),
      ),
    );
  }

  Future<void> uploadImageToFirebase(String filePath) async {
    File file = File(filePath);
    try {
      await storage.ref('rooms/${file.uri.pathSegments.last}').putFile(file);
    } catch (e) {
      debugPrint('Error uploading image: $e');
    }
  }
}