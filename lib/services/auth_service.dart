//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:revup/classes/authentication_exception.dart';

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
    try {
      rememberMe == true ? await _firebaseAuth.setPersistence(Persistence.LOCAL) : await FirebaseAuth.instance.setPersistence(Persistence.NONE);
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch(e) {
      throw AuthenticationException();
    }
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

  Future<User?> signInAnonymously() async {
    try {
      await _firebaseAuth.setPersistence(Persistence.NONE);
      UserCredential credential = await _firebaseAuth.signInAnonymously();
      return credential.user;
    } catch(e) {
      throw AuthenticationException();
    }
  }

  Future<User?> signInWithGoogle(bool rememberMe) async {
    rememberMe == true ? await _firebaseAuth.setPersistence(Persistence.LOCAL) : await _firebaseAuth.setPersistence(Persistence.NONE);
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) throw AuthenticationException();

      final googleAuth = await googleUser.authentication;
      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential credential = await _firebaseAuth.signInWithCredential(googleCredential);
      notifyListeners();
      return credential.user;
    } catch (e) {
      // TODO
      throw AuthenticationException();
    }
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
