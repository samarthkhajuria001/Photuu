import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth show User;

class AuthUser {
  final String email;
  final String uid;

  AuthUser({required this.email, required this.uid});

  factory AuthUser.fromFireabse(FirebaseAuth.User user) {
    return AuthUser(email: user.email!, uid: user.uid);
  }
}
