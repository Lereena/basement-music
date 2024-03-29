// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD9rBToR95D-JJtO5E9id0iEoVCUr4bUyY',
    appId: '1:692971631983:web:9994f7008ed184197da49a',
    messagingSenderId: '692971631983',
    projectId: 'basement-music',
    authDomain: 'basement-music.firebaseapp.com',
    storageBucket: 'basement-music.appspot.com',
    measurementId: 'G-31BVVWX112',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1SprRQcoPNy5zNOtJOsHTM0HDy4SosT8',
    appId: '1:692971631983:android:228c5da2b5da84697da49a',
    messagingSenderId: '692971631983',
    projectId: 'basement-music',
    storageBucket: 'basement-music.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC4aAJMQrNuNe3FIBiT21_cLFmxy1H9e38',
    appId: '1:692971631983:ios:24fc8442b6e06c7b7da49a',
    messagingSenderId: '692971631983',
    projectId: 'basement-music',
    storageBucket: 'basement-music.appspot.com',
    iosClientId: '692971631983-lpkolegucp2cm69jgi6blncea628pt49.apps.googleusercontent.com',
    iosBundleId: 'com.example.basementMusic',
  );
}
