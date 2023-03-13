import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:photuu/main.dart';
import 'package:photuu/models/post.dart';
import 'package:photuu/providers/user_providers.dart';
import 'package:photuu/services/auth/auth_services.dart';
import 'package:photuu/services/auth/firebase_auth_provider.dart';
import 'package:photuu/services/storage/firestore_methods.dart';
import 'package:photuu/utils/colors.dart';
import 'package:photuu/models/user.dart' as models;
import 'package:photuu/utils/constants.dart';
import 'package:photuu/utils/utils.dart';
import 'package:provider/provider.dart';

class SearchedUser extends StatefulWidget {
  const SearchedUser({super.key});

  @override
  State<SearchedUser> createState() => _SearchedUserState();
}

class _SearchedUserState extends State<SearchedUser> {
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  int _currentTab = 0;
  void onTap(int page) {
    setState(() {
      _currentTab = page;
      _pageController.jumpToPage(_currentTab);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userMap = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map<String, dynamic>;
    models.User user = models.User(
      email: userMap['email'],
      username: userMap['username'],
      uid: userMap['uid'],
      bio: userMap['bio'],
      followers: userMap['followers'],
      following: userMap['following'],
      posts: userMap['posts'],
      profileUrl: userMap['profileUrl'],
    );

    final models.User loggedinUser =
        Provider.of<UserProvider>(context, listen: true).getUser;

    bool isFollowing = false;
    if (loggedinUser.following.contains(user.uid)) {
      isFollowing = true;
    }

    // models.User user =
    //     Provider.of<UserProvider>(context, listen: false).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(user.username),
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        children: [
                          SimpleDialogOption(
                            onPressed: () async {
                              String res =
                                  await AuthServices.firebase().logOutUser();
                              if (res == 'success') {
                                if (mounted) {
                                  showSnackBar(context, 'Logged out');
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, loginScreen, (route) => false);
                                }
                              }
                            },
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            child: const Text(
                              'Sign out',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          SimpleDialogOption(
                            onPressed: () => Navigator.of(context).pop(),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.more_vert))
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.profileUrl),
                  radius: 50,
                ),
                Column(
                  children: [
                    Text(
                      user.posts.length.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Posts',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      user.followers.length.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Followers',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      user.following.length.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Following',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    )
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                user.username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: 22,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(user.bio),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
                width: double.infinity,
                child: isFollowing
                    ? ElevatedButton(
                        onPressed: () async {
                          String res = await FirestoreStorage()
                              .followUnFollow(uid: user.uid, follow: false);
                          Provider.of<UserProvider>(context, listen: false)
                              .refreshUser();
                        },
                        child: Text('following'),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          String res = await FirestoreStorage()
                              .followUnFollow(uid: user.uid, follow: true);
                          Provider.of<UserProvider>(context, listen: false)
                              .refreshUser();
                        },
                        child: Text('follow'))),
          ),
          isFollowing
              ? FollowUnfollowExtraWidgets(
                  context: context,
                  user: user,
                  pageController: _pageController,
                  onTap: onTap,
                )
              : UnfollowdHomeWidget(),
        ],
      )),
    );
  }
}

class AccountAllPhotoGrid extends StatelessWidget {
  final models.User user;
  const AccountAllPhotoGrid({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              if (snapshot.hasData) {
                return Container(
                  child: GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3),
                      itemBuilder: (context, index) {
                        Map<String, dynamic> snap =
                            snapshot.data!.docs[index].data();
                        return AccountScreenGridTile(
                          context: context,
                          index: index,
                          snap: snap,
                        );
                      }),
                );
              } else {
                return showSnackBar(context, 'some error occured');
              }
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        });
  }
}

class AccountScreenGridTile extends StatelessWidget {
  final BuildContext context;
  final int index;
  final Map<String, dynamic> snap;
  const AccountScreenGridTile({
    super.key,
    required this.context,
    required this.index,
    required this.snap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSnackBar(context, 'Not implemented yet chota hi dekh abhi');
      },
      child: Container(
        child: Image.network(
          snap['postUrl'],
          fit: BoxFit.cover,
          alignment: FractionalOffset.topCenter,
        ),
      ),
    );
  }
}

class UnfollowdHomeWidget extends StatelessWidget {
  const UnfollowdHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline_sharp),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'This account is Private',
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    'Follow this account ot see their photos and videos.',
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FollowUnfollowExtraWidgets extends StatelessWidget {
  final BuildContext context;
  final models.User user;
  final PageController pageController;
  final Function(int) onTap;
  const FollowUnfollowExtraWidgets(
      {super.key,
      required this.context,
      required this.user,
      required this.pageController,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Story highligts',
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Watch his favourite stories',
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_circle,
                  ),
                  iconSize: 64,
                ),
                Container(
                  height: 100,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[850],
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  style: IconButton.styleFrom(),
                  onPressed: () => onTap(0),
                  icon: Icon(Icons.grid_on_outlined)),
              IconButton(
                  onPressed: () => onTap(1),
                  icon: Icon(Icons.photo_camera_front_outlined))
            ],
          ),
          Container(
            height: 400,
            padding: EdgeInsets.only(bottom: 0),
            child: PageView(
              controller: pageController,
              children: [
                AccountAllPhotoGrid(
                  user: user,
                ),
                Center(child: Text('No data'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
