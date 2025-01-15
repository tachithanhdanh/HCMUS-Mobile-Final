import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY_WEB'] ?? 'MISSING_API_KEY_WEB',
        appId: dotenv.env['FIREBASE_APP_ID_WEB'] ?? 'MISSING_APP_ID_WEB',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID_WEB'] ??
            'MISSING_MESSAGING_SENDER_ID_WEB',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'MISSING_PROJECT_ID',
        authDomain:
            dotenv.env['FIREBASE_AUTH_DOMAIN_WEB'] ?? 'MISSING_AUTH_DOMAIN_WEB',
        storageBucket:
            dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'MISSING_STORAGE_BUCKET',
        measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID_WEB'] ??
            'MISSING_MEASUREMENT_ID_WEB',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptions(
          apiKey: dotenv.env['FIREBASE_API_KEY_ANDROID'] ??
              'MISSING_API_KEY_ANDROID',
          appId:
              dotenv.env['FIREBASE_APP_ID_ANDROID'] ?? 'MISSING_APP_ID_ANDROID',
          messagingSenderId:
              dotenv.env['FIREBASE_MESSAGING_SENDER_ID_ANDROID'] ??
                  'MISSING_MESSAGING_SENDER_ID_ANDROID',
          projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'MISSING_PROJECT_ID',
          storageBucket:
              dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'MISSING_STORAGE_BUCKET',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
