import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String email;
  final String bio;
  final String profileUrl;
  final List following;
  final List followers;
  final List posts;

  User(
      {required this.username,
      required this.uid,
      required this.email,
      required this.bio,
      required this.profileUrl,
      required this.following,
      required this.followers,
      required this.posts});

  factory User.fromJson(DocumentSnapshot snap) {
    Map<String, dynamic> snapData = snap.data() as Map<String, dynamic>;
    return User(
        username: snapData['username'],
        uid: snapData['uid'],
        email: snapData['email'],
        bio: snapData['bio'],
        profileUrl: snapData['profileUrl'],
        following: snapData['following'],
        followers: snapData['followers'],
        posts: snapData['posts']);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'uid': uid,
      'email': email,
      'bio': bio,
      'profileUrl': profileUrl,
      'following': following,
      'followers': followers,
      'posts': posts
    };
  }
}
