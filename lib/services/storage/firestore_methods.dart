import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photuu/models/post.dart';
import 'package:photuu/models/user.dart' as models;
import 'package:photuu/services/auth/authUser.dart';
import 'package:photuu/services/auth/auth_services.dart';
import 'package:photuu/services/storage/cloud_storage_provider.dart';
import 'dart:typed_data';

import 'package:photuu/services/storage/storage_provider.dart';

class FirestoreStorage implements StorageProvider {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<String> createPost(
      {required models.User user,
      required Uint8List file,
      required String description}) async {
    String result = 'some error occured';
    try {
      if (AuthServices.firebase().currentUser != null) {
        Map<String, String> res = await CloudStorage().uploadToCloudStorage(
            uid: user.uid, file: file, isProfilePic: false);
        if (res['result'] == 'success') {
          Post post = Post(
              username: user.username,
              uid: user.uid,
              postId: res['postId']!,
              postUrl: res['downloadUrl']!,
              profileUrl: user.profileUrl,
              description: description,
              datePublished: DateTime.now().toIso8601String(),
              likes: []);

          await _firebaseFirestore
              .collection('posts')
              .doc(post.postId)
              .set(post.toJson());

          await _firebaseFirestore.collection('users').doc(user.uid).update({
            'posts': FieldValue.arrayUnion([post.postId])
          });
          result = 'success';
        } else {
          result = 'user not logged in';
        }
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  @override
  Future<String> deletePost(
      {required String postUid, required String uid}) async {
    String res = "some error occured";
    try {
      await _firebaseFirestore.collection('posts').doc(postUid).delete();
      await _firebaseFirestore.collection('users').doc(uid).update({
        'posts': FieldValue.arrayRemove([postUid])
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  @override
  Future<void> likePost({required String PostUid}) {
    // TODO: implement likePost
    throw UnimplementedError();
  }

  @override
  Future<models.User?> refreshCompleteUserDetails() async {
    AuthUser? user = AuthServices.firebase().currentUser;
    if (user != null) {
      DocumentSnapshot snap =
          await _firebaseFirestore.collection('users').doc(user.uid).get();
      models.User refreshedUser = models.User.fromJson(snap);
      return refreshedUser;
    } else {
      return null;
    }
  }

  @override
  Future<bool> isLoggedinUserPost({required postUserUid}) async {
    AuthUser? user = AuthServices.firebase().currentUser;
    if (user != null) {
      if (postUserUid == user.uid) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Future<String> followUnFollow(
      {required String uid, required bool follow}) async {
    String res = 'some error occured';
    if (AuthServices.firebase().currentUser != null) {
      if (follow) {
        await _firebaseFirestore
            .collection('users')
            .doc(AuthServices.firebase().currentUser!.uid)
            .update({
          'following': FieldValue.arrayUnion([uid])
        });
        res = 'success';
      } else {
        await _firebaseFirestore
            .collection('users')
            .doc(AuthServices.firebase().currentUser!.uid)
            .update({
          'following': FieldValue.arrayRemove([uid])
        });
        res = 'success';
      }
    }
    return res;
  }

  // @override
  // // TODO: implement getCurrentUserAllPostsSnapshot
  // Stream<QuerySnapshot<Map<String, dynamic>>?> get getCurrentUserAllPostsSnapshot async{
  //   AuthUser? user = AuthServices.firebase().currentUser;
  //   if (user != null) {
  //     return await _firebaseFirestore
  //         .collection('posts')
  //         .where('uid', isEqualTo: user.uid)
  //         .snapshots();
  //   } else {
  //     return null;
  //   }
  // }

  @override
  Future<String> updateUserData(
      {required String username,
      required String bio,
      Uint8List? profilePicFile}) async {
    String res = 'some error occured';
    if (AuthServices.firebase().currentUser != null) {
      if (profilePicFile != null) {
        Map<String, String> result = await CloudStorage().uploadToCloudStorage(
            uid: AuthServices.firebase().currentUser!.uid,
            file: profilePicFile,
            isProfilePic: true);
        if (result['result'] == 'success') {
          await _firebaseFirestore
              .collection('users')
              .doc(AuthServices.firebase().currentUser!.uid)
              .update(
            {
              'username': username,
              'bio': bio,
              'profileUrl': result['downloadUrl']
            },
          );
          res = 'success';
        }
      } else {
        await _firebaseFirestore
            .collection('users')
            .doc(AuthServices.firebase().currentUser!.uid)
            .update(
          {
            'username': username,
            'bio': bio,
          },
        );
        res = 'success';
      }
    }
    return res;
  }

  @override
  Future<void> likeUnLike({required String postId, required bool like}) async {
    final currentUser = AuthServices.firebase().currentUser;
    if (currentUser != null) {
      try {
        if (like) {
          print('likinging');
          await _firebaseFirestore.collection('posts').doc(postId).update({
            'likes': FieldValue.arrayUnion([currentUser.uid])
          });
        } else {
          print('unlikinging');
          await _firebaseFirestore.collection('posts').doc(postId).update({
            'likes': FieldValue.arrayRemove([currentUser.uid])
          });
        }
      } catch (err) {
        print(err.toString());
      }
    }
  }
}
