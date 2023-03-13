import 'dart:typed_data';

import 'package:photuu/services/auth/authUser.dart';
import 'package:photuu/services/auth/auth_provider.dart';
import 'package:photuu/services/auth/firebase_auth_provider.dart';

class AuthServices implements AuthProvider {
  final AuthProvider provider;
  AuthServices(this.provider);
  factory AuthServices.firebase() => AuthServices(FirebaseAuthProvider());

  @override
  Future<String> createUser(
      {required String email,
      required String username,
      required String password}) async {
    return await provider.createUser(
        email: email, password: password, username: username);
  }

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<String> logOutUser() async {
    return await provider.logOutUser();
  }

  @override
  Future<String> loginUser(
      {required String email, required String password}) async {
    return await provider.loginUser(email: email, password: password);
  }

  @override
  Future<String> updateUser(
      {required String username,
      required String bio,
      required Uint8List profilePicFile}) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
