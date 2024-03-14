import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagrim/data/firebase_service/storage.dart';
import 'package:instagrim/util/exception.dart';

import 'firestore.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseException catch (e) {
      throw Exceptions(e.message.toString());
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String passwordConfirme,
    required String username,
    required String bio,
    required File profile,
  }) async {
    String url;
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        if (password == passwordConfirme) {
          // create user with email and password
          await _auth.createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
          // upload profile image on storage

          if (profile != File('')) {
            url =
                await StorageMethod().uploadImageToStorage('Profile', profile);
          } else {
            url = '';
          }

          // get information with firestore

          await Firebase_Firestore().createUser(
            email: email,
            username: username,
            bio: bio,
            profile: url == ''
                ? 'https://firebasestorage.googleapis.com/v0/b/instagrim-3ec80.appspot.com/o/person.png?alt=media&token=42202cc2-e5db-4d93-9aa2-44964a9f06b0'
                : url,
          );
        } else {
          throw Exceptions('password and confirm password should be same');
        }
      } else {
        throw Exceptions('enter all the fields');
      }
    } on FirebaseException catch (e) {
      throw Exceptions(e.message.toString());
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to send reset email: ${e.message}');
    }
  }
}
