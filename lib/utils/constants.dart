import 'package:flutter/material.dart';

import '../screens/feed_screen.dart';
import '../screens/new_post.dart';
import '../screens/serach_user_screen.dart';
import '../screens/user_account_screen.dart';

const String defualtImageUrl =
    'https://firebasestorage.googleapis.com/v0/b/photuu-app.appspot.com/o/coreData%2FdefaultImg.jpeg?alt=media&token=b751e802-7706-419e-a644-02e3badf84c6';

var networkImage =
    'https://images.unsplash.com/photo-1668518047205-8337ad18badb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80';

const List<Widget> navigationScreens = [
  FeedScreen(),
  SearchUserScreen(),
  PostScreen(),
  Center(child: Text('notifications')),
  UserAccount(),
];
