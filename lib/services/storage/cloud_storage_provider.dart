import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:photuu/services/auth/auth_services.dart';
import 'package:uuid/uuid.dart';

class CloudStorage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<Map<String, String>> uploadToCloudStorage(
      {required String uid,
      required Uint8List file,
      required bool isProfilePic}) async {
    Map<String, String> res = {'result': 'some error occured'};
    try {
      if (AuthServices.firebase().currentUser != null) {
        Reference ref = _storage.ref().child(uid);
        if (isProfilePic == true) {
          ref = ref.child('profilePics');
        } else {
          ref = ref.child('posts');
        }
        final String postId = Uuid().v4();
        res['postId'] = postId;
        ref = ref.child(postId);

        UploadTask uploadTask = ref.putData(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        res['downloadUrl'] = downloadUrl;
        res['result'] = 'success';
      } else {
        res['result'] = 'user not logged in';
      }
    } catch (err) {
      res['result'] = err.toString();
    }
    return res;
  }
}
