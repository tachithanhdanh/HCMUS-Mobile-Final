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
    // print("Dotenv loaded: ${dotenv.env}");

    // Kiểm tra và chỉ khởi tạo Firebase nếu chưa được khởi tạo
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print("Firebase initialized successfully.");
    } else {
      print("Firebase already initialized.");
    }
  } catch (e, stackTrace) {
    print("Error occurred during initialization: $e");
    print("Stack Trace: $stackTrace");
  }

  // // In thông tin Firebase
  // FirebaseApp app = Firebase.apps.first; // Lấy app đầu tiên (hoặc mặc định)
  // print("Firebase App Name: ${app.name}");
  // print("Firebase Options:");
  // print("  API Key: ${app.options.apiKey}");
  // print("  App ID: ${app.options.appId}");
  // print("  Messaging Sender ID: ${app.options.messagingSenderId}");
  // print("  Project ID: ${app.options.projectId}");
  // print("  Auth Domain: ${app.options.authDomain}");
  // print("  Storage Bucket: ${app.options.storageBucket}");
  // print("  Measurement ID: ${app.options.measurementId}");

  runApp(const MyApp());
}
