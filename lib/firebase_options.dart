import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCSSRhmCYmUfhkWzb2NwlFnXHPewkuvtEY',
    appId: '1:1004204446070:web:e751b1af9fc8b9c16a6a57',
    messagingSenderId: '1004204446070',
    projectId: 'bafna-vault',
    authDomain: 'bafna-vault.firebaseapp.com',
    storageBucket: 'bafna-vault.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5aTleFOVOboIH5VfsksdAX4rzJatVCaU',
    appId: '1:1004204446070:android:96e7b845b7f7840a6a6a57',
    messagingSenderId: '1004204446070',
    projectId: 'bafna-vault',
    storageBucket: 'bafna-vault.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDhphIgvPfjItV6IL0pDTpegbNf_24h5PU',
    appId: '1:1004204446070:ios:8c38a6e6559adab36a6a57',
    messagingSenderId: '1004204446070',
    projectId: 'bafna-vault',
    storageBucket: 'bafna-vault.firebasestorage.app',
    iosBundleId: 'com.example.bafnaVault',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDhphIgvPfjItV6IL0pDTpegbNf_24h5PU',
    appId: '1:1004204446070:ios:8c38a6e6559adab36a6a57',
    messagingSenderId: '1004204446070',
    projectId: 'bafna-vault',
    storageBucket: 'bafna-vault.firebasestorage.app',
    iosBundleId: 'com.example.bafnaVault',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCSSRhmCYmUfhkWzb2NwlFnXHPewkuvtEY',
    appId: '1:1004204446070:web:a05440bb980eb02a6a6a57',
    messagingSenderId: '1004204446070',
    projectId: 'bafna-vault',
    authDomain: 'bafna-vault.firebaseapp.com',
    storageBucket: 'bafna-vault.firebasestorage.app',
  );
}
