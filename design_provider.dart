import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;  // Ensure this package is correctly imported
import 'package:cloud_firestore/cloud_firestore.dart';

class DesignProvider with ChangeNotifier {
  String? imagePath;
  List<String> designOptions = [];
  String savedDesign = "";

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void uploadImage(String path) {
    imagePath = path;
    notifyListeners();
  }

  Future<void> processImage(String path) async {
    final imageFile = File(path);
    final imageBytes = await imageFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);

    img.Image resizedImage = img.copyResize(originalImage!, width: 224, height: 224);
    final processedImagePath = path.replaceAll('.jpg', '_processed.jpg');
    final processedImageFile = File(processedImagePath)
      ..writeAsBytesSync(img.encodeJpg(resizedImage));

    await fetchDesignOptions(processedImageFile.path);
  }

  Future<void> fetchDesignOptions(String processedImagePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://your-api-endpoint.com/get-designs'), // Replace with your API endpoint
    );

    request.files.add(await http.MultipartFile.fromPath('image', processedImagePath));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final result = String.fromCharCodes(responseData);
      designOptions = List<String>.from(json.decode(result));
      await saveDesignSuggestionsToFirestore(designOptions);
    } else {
      throw Exception('Failed to load design options');
    }

    notifyListeners();
  }

  Future<void> saveDesignSuggestionsToFirestore(List<String> suggestions) async {
    await firestore.collection('designSuggestions').add({
      'suggestions': suggestions,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void saveDesign() {
    savedDesign = designOptions.join(", ");
    notifyListeners();
  }

  Future<void> suggestChanges(String userRequest) async {
    designOptions.add("New suggestion based on your request: $userRequest");
    notifyListeners();
  }
}