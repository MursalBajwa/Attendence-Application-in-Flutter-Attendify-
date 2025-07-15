import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAuth {
  static Future<bool> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Create the Firebase Auth user
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String userId = credential.user!.uid;

      // 2. Reference the "users" collection in Firestore
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // 3. Use the Firebase UID as the document ID
      await users.doc(userId).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'profilePictureUrl': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // (Optional) Send email verification
      await credential.user!.sendEmailVerification();

      return true;
    } catch (e) {
      debugPrint("Signup error: $e");
      return false;
    }
  }

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      debugPrint("Login error: $e");
      return false;
    }
  }
}
