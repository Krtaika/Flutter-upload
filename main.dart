import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'design_provider.dart';
import 'image_upload_screen.dart';
import 'design_options_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp()); // Removed const
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DesignProvider(),
      child: MaterialApp(
        title: 'Interior Design App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(), // Removed const
          '/upload': (context) => ImageUploadScreen(), // Removed const
          '/options': (context) => DesignOptionsScreen(), // Removed const
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Interior Design App')), // Regular Text
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/upload');
          },
          child: Text('Upload Room Image'), // Regular Text
        ),
      ),
    );
  }
}