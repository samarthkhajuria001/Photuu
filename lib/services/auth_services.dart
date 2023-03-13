// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:photuu/models/post.dart';
// import 'package:photuu/models/user.dart' as models;
// import 'package:photuu/services/storage_methods.dart';
// import 'package:photuu/services/user.dart';
// import 'package:photuu/utils/constants.dart';
// import 'package:uuid/uuid.dart';

// class Authmethods {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//   Future<String> signUpUsingEmailAndPassword(
//       {required String email,
//       required String password,
//       required String username}) async {
//     String res = 'Some error occuered';

//     try {
//       if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
//         UserCredential cred = await _auth.createUserWithEmailAndPassword(
//             email: email, password: password);

//         models.User user = models.User(
//           username: username,
//           uid: cred.user!.uid,
//           email: email,
//           bio: 'Luv is Luub',
//           profileUrl: defualtImageUrl,
//           following: [],
//           followers: [],
//           posts: [],
//         );
//         await _firebaseFirestore
//             .collection('users')
//             .doc(cred.user!.uid)
//             .set(user.toJson());
//         res = 'success';
//       }
//       return res;
//     } catch (err) {
//       return err.toString();
//     }
//   }

//   Future<String> loginUserUsingEmailAndPassword(
//       {required String email, required String password}) async {
//     String res = 'Some error occured';
//     try {
//       if (email.isNotEmpty && password.isNotEmpty) {
//         UserCredential cred = await _auth.signInWithEmailAndPassword(
//             email: email, password: password);
//         AuthUser().setUser();
//         res = 'sucess';
//       }

//       return res;
//     } catch (err) {
//       return err.toString();
//     }
//   }

//   Future<models.User> getCurrentUserDetails() async {
//     print('model user was called');

//     DocumentSnapshot snap = await _firebaseFirestore
//         .collection('users')
//         .doc(_auth.currentUser!.uid)
//         .get();
//     return models.User.fromJson(snap);
//   }

//   Future<String> PostImage(
//       {required Uint8List file,
//       required String username,
//       required String uid,
//       required String profileUrl,
//       required String description}) async {
//     String res = 'Some error occured';
//     try {
//       String downloadUrl =
//           await StorageMethods().UploadToStorage(uid: uid, file: file);
//       Post post = Post(
//           username: username,
//           uid: uid,
//           postId: Uuid().v1(),
//           postUrl: downloadUrl,
//           profileUrl: profileUrl,
//           description: description,
//           datePublished: DateTime.now().toIso8601String(),
//           likes: []);
//       await _firebaseFirestore
//           .collection('posts')
//           .doc(post.postId)
//           .set(post.toJson());

//       res = 'success';
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> logOut() async {
//     String res = 'some error occured';
//     try {
//       await FirebaseAuth.instance.signOut();
//       res = 'success';
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }
// }
