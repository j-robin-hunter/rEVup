//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<List> get user async {
    List list = [];
    User? user = _firebaseAuth.currentUser;
    user ??= await _firebaseAuth.authStateChanges().first;
    list.add(user);
    return list;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password, bool rememberMe) async {
    rememberMe == true ? await FirebaseAuth.instance.setPersistence(Persistence.LOCAL) : await FirebaseAuth.instance.setPersistence(Persistence.NONE);
    UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
    return credential.user;
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await FirebaseAuth.instance.setPersistence(Persistence.NONE);
    UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    notifyListeners();
    User? user = credential.user;
    if (user != null) {
      await verifyEmailAddress(user);
    }
    return user;
  }

  Future<void> verifyEmailAddress(User user) async {
    if (user.emailVerified == false) {
      user.sendEmailVerification();
    }
  }

  Future<void> signInWithGoogle(bool rememberMe) async {
    rememberMe == true ? await _firebaseAuth.setPersistence(Persistence.LOCAL) : await _firebaseAuth.setPersistence(Persistence.NONE);
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(googleCredential);
    } catch (e) {
      // TODO
      print('Error signInWithGoogle $e');
    }
    notifyListeners();
  }

  Future<void> resetPasswordRequest(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUserEmail(String email, String password) async {
    try {
      List users = await user;
      await signInWithEmailAndPassword(users[0].email!, password, false);
      await users[0].updateEmail(email);
      await verifyEmailAddress(users[0]);
      notifyListeners();
    } catch(e) {
      throw Exception('Unable to determine current user');
    }
  }

  Future<void> updateUserDisplayName(User user, String name) async {
    await user.updateDisplayName(name);
    notifyListeners();
  }

  Future<void> updateUserPhotoURL(User user, String photoURL) async {
    await user.updatePhotoURL(photoURL);
    notifyListeners();
  }

  Future<void> signOut() async {
    await googleSignIn.disconnect();
    await _firebaseAuth.signOut();
    notifyListeners();
  }
}
