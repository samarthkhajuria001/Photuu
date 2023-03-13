import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photuu/providers/user_providers.dart';
import 'package:photuu/services/storage/firestore_methods.dart';
import 'package:photuu/utils/colors.dart';
import 'package:photuu/utils/like_animation.dart';
import 'package:photuu/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as models;

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  void PostOptions(
      {required bool isMine,
      required String postUid,
      required String uid}) async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              isMine
                  ? SimpleDialogOption(
                      onPressed: () async {
                        String res = await FirestoreStorage()
                            .deletePost(postUid: postUid, uid: uid);

                        if (res == 'success') {
                          Provider.of<UserProvider>(context, listen: false)
                              .refreshUser();

                          showSnackBar(context, res);
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Delete'),
                    )
                  : SimpleDialogOption(
                      onPressed: () {
                        showSnackBar(context, 'Please dont report me');
                      },
                      child: const Text('Report'),
                    ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  bool islikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    models.User user = Provider.of<UserProvider>(context, listen: true).getUser;
    print('user is ');
    print(user.username);

    bool isAlreadyLiked = widget.snap['likes'].contains(user.uid);
    print('already liked');
    print(isAlreadyLiked);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.snap['profileUrl']),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(widget.snap['username']),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    if (await FirestoreStorage()
                        .isLoggedinUserPost(postUserUid: widget.snap['uid'])) {
                      PostOptions(
                          isMine: true,
                          postUid: widget.snap['postId'],
                          uid: widget.snap['uid']);
                    } else {
                      PostOptions(
                        isMine: false,
                        postUid: widget.snap['postId'],
                        uid: widget.snap['uid'],
                      );
                    }
                  },
                  icon: const Icon(Icons.more_vert))
            ],
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreStorage().likeUnLike(
                  postId: widget.snap['postId'], like: !isAlreadyLiked);
              setState(() {
                islikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .5,
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      widget.snap['postUrl'],
                      fit: BoxFit.cover,
                      alignment: FractionalOffset.topCenter,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: islikeAnimating ? 1 : 0,
                  child: LikedAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                    isAnimating: islikeAnimating,
                    smallLike: false,
                    duration: Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        islikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikedAnimation(
                isAnimating: isAlreadyLiked,
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      print('like pressed');
                      await FirestoreStorage().likeUnLike(
                          postId: widget.snap['postId'], like: !isAlreadyLiked);
                    },
                    icon: isAlreadyLiked
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : const Icon(Icons.favorite_border,
                            color: Colors.white)),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.comment_rounded,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send_outlined,
                    color: Colors.white,
                  )),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.bookmark_outline,
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Text('${widget.snap['likes'].length} Likes'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: widget.snap['username'],
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold)),
              TextSpan(text: ' ${widget.snap['description']}')
            ])),
          ),
          GestureDetector(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('View all 21 commnts'),
          )),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Text(
              DateFormat.yMMMd()
                  .format(DateTime.parse(widget.snap['datePublished'])),
              style: const TextStyle(fontSize: 14, color: secondaryColor),
            ),
          )
        ],
      ),
    );
  }
}
