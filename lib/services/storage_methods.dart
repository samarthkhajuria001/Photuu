// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:uuid/uuid.dart';

// class StorageMethods {
//   FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<String> UploadToStorage(
//       {required String uid,
//       required Uint8List file,
//       bool isProfilePic = false}) async {
//     Reference ref = _storage.ref().child(uid);
//     if (isProfilePic) {
//       ref = ref.child('profilePics');
//     } else {
//       ref = ref.child('posts');
//     }
//     ref = ref.child(const Uuid().v4());

//     UploadTask uploadTask = ref.putData(file);
//     TaskSnapshot snapshot = await uploadTask;
//     String downlaodUrl = await snapshot.ref.getDownloadURL();
//     print('download usrl is ');
//     print(downlaodUrl);
//     return downlaodUrl;
//   }
// }
