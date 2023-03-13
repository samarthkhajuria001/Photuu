import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String uid;
  final String postId;
  final String postUrl;
  final String profileUrl;
  final String description;
  final String datePublished;
  final List<String> likes;

  Post(
      {required this.username,
      required this.uid,
      required this.postId,
      required this.postUrl,
      required this.profileUrl,
      required this.description,
      required this.datePublished,
      required this.likes});

  factory Post.fromJson(DocumentSnapshot snap) {
    Map<String, dynamic> snapData = snap.data() as Map<String, dynamic>;
    return Post(
        username: snapData['username'],
        uid: snapData['uid'],
        postId: snapData['postId'],
        postUrl: snapData['postUrl'],
        profileUrl: snapData['profileUrl'],
        description: snapData['description'],
        datePublished: snapData['datePublished'],
        likes: snapData['likes']);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'uid': uid,
      'postId': postId,
      'postUrl': postUrl,
      'profileUrl': profileUrl,
      'description': description,
      'datePublished': datePublished,
      'likes': likes
    };
  }
}
