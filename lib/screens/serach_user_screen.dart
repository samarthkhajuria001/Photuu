import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:photuu/main.dart';
import 'package:photuu/utils/colors.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  late TextEditingController _searchTextController;
  @override
  void initState() {
    _searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  bool searching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            controller: _searchTextController,
            decoration: InputDecoration(
                label: Text('Enter the username'),
                contentPadding: EdgeInsets.symmetric(horizontal: 16)),
            onTap: () {
              setState(() {
                searching = false;
              });
            },
            onFieldSubmitted: (value) {
              setState(() {
                searching = true;
              });
            },
          ),
        ),
        body: searching
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: _searchTextController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: (snapshot.data!).docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              onTap: () => Navigator.of(context).pushNamed(
                                  searchedUserScreen,
                                  arguments:
                                      (snapshot.data!).docs[index].data()),
                              title: Text((snapshot.data! as dynamic)
                                  .docs[index]['username']),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['profileUrl'],
                                ),
                              ));
                        });
                  } else {
                    return LinearProgressIndicator();
                  }
                },
              )
            : const Center(
                child: Text('Some random posts will be here in future')));
  }
}
