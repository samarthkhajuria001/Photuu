import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:photuu/models/user.dart' as models;

abstract class StorageProvider {
  Future<String> createPost(
      {required models.User user,
      required Uint8List file,
      required String description});

  Future<String> deletePost({required String postUid, required String uid});

  Future<void> likePost({required String PostUid});

  Future<models.User?> refreshCompleteUserDetails();
  // Stream<QuerySnapshot<Map<String, dynamic>>?>
  //     get getCurrentUserAllPostsSnapshot;

  Future<bool> isLoggedinUserPost({required postUserUid});

  Future<String> followUnFollow({required String uid, required bool follow});
  Future<String> updateUserData(
      {required String username,
      required String bio,
      Uint8List profilePicFile});
  Future<void> likeUnLike({required String postId, required bool like});
}
