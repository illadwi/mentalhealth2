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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDrrq2rN5YDf9rRKZEeefvQl_GHSQNW6gM",
    appId: "1:604794270644:web:f467f9a0f2a7d4a65738e1",
    messagingSenderId: "604794270644",
    projectId: "mentalhealth-df762",
    storageBucket: "mentalhealth-df762.appspot.com",
    authDomain: "mentalhealth-df762.firebaseapp.com",
    measurementId: "G-TK3KQ8MCB8",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyDrrq2rN5YDf9rRKZEeefvQl_GHSQNW6gM",
    appId: "1:604794270644:android:0de83565bf9d8c7f5738e1",
    messagingSenderId: "604794270644",
    projectId: "mentalhealth-df762",
    storageBucket: "mentalhealth-df762.appspot.com",
  );
}
