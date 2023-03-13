import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photuu/services/auth/authUser.dart';
import 'package:photuu/services/auth/auth_provider.dart';
import 'package:photuu/models/user.dart' as models;
import 'package:photuu/services/auth/auth_services.dart';
import 'package:photuu/services/storage/cloud_storage_provider.dart';
import 'package:photuu/services/storage/firestore_methods.dart';
import 'package:photuu/utils/constants.dart';

class FirebaseAuthProvider implements AuthProvider {
  final FirebaseAuth _firebaseAuthInstance = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  @override
  Future<String> createUser(
      {required String email,
      required String username,
      required String password}) async {
    String res = 'some error occured';
    try {
      await _firebaseAuthInstance.createUserWithEmailAndPassword(
          email: email, password: password);

      if (currentUser != null) {
        models.User modelUser = models.User(
          username: username,
          bio: 'Luv is Luubb',
          email: currentUser!.email,
          uid: currentUser!.uid,
          profileUrl: defualtImageUrl,
          followers: [],
          following: [],
          posts: [],
        );
        await _firebaseFirestoreInstance
            .collection('users')
            .doc(currentUser!.uid)
            .set(modelUser.toJson());
        String isLoggedOut = await logOutUser();
        if (isLoggedOut == 'success') {
          res = 'Please Login to continue';
        } else {
          res = isLoggedOut;
        }
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  @override
  AuthUser? get currentUser {
    User? user = _firebaseAuthInstance.currentUser;
    if (user != null) {
      return AuthUser.fromFireabse(user);
    } else {
      return null;
    }
  }

  @override
  Future<String> logOutUser() async {
    String res = 'Some error occured';
    try {
      await _firebaseAuthInstance.signOut();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  @override
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error occured';
    try {
      await _firebaseAuthInstance.signInWithEmailAndPassword(
          email: email, password: password);
      if (currentUser != null) {
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
