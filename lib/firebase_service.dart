// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sigin () async {
    _auth.signInAnonymously();
  }
  Future<Map<String, dynamic>?> loadUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userData =
            await _firestore.collection('users').doc(user.uid).get();
        return userData.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
    return null;
  }

  Future<void> saveData(
      String lastName, String surName, String firstName) async {
    User? user = _auth.currentUser;
    try {
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'firstName': firstName,
          'lastName': lastName,
          'surName': surName,
        });
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
