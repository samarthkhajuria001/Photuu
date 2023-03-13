import 'package:flutter/foundation.dart';
import 'package:photuu/services/auth/authUser.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<String> loginUser({
    required String email,
    required String password,
  });
  Future<String> createUser({
    required String email,
    required String username,
    required String password,
  });

  Future<String> logOutUser();
}
