import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:basement_music/models/app_user.dart';
import 'package:basement_music/rest_client.dart';

class AuthRepository {
  AuthRepository(this._restClient);

  final RestClient _restClient;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentFirebaseUser => _firebaseAuth.currentUser;

  Future<void> signInWithGoogle() async {
    final provider = GoogleAuthProvider();
    if (kIsWeb) {
      await _firebaseAuth.signInWithPopup(provider);
    } else {
      await _firebaseAuth.signInWithProvider(provider);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<AppUser> getMe() => _restClient.getMe();

  Future<AppUser> register(String code) => _restClient.register({'code': code});
}
