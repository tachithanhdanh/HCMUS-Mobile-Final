import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Tải file .env
    await dotenv.load(fileName: "assets/.env");

    // Kiểm tra và khởi tạo Firebase
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    }
    print("Firebase initialized successfully.");
  } catch (e, stackTrace) {
    print("Error occurred during initialization: $e");
    print("Stack Trace: $stackTrace");
  }

  runApp(MyApp());
}
