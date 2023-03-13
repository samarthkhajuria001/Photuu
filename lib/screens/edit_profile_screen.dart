import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photuu/models/user.dart' as models;
import 'package:photuu/providers/user_providers.dart';
import 'package:photuu/services/storage/firestore_methods.dart';
import 'package:photuu/utils/colors.dart';
import 'package:photuu/utils/utils.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  Uint8List? _file;
  late models.User user;
  @override
  void initState() {
    user = Provider.of<UserProvider>(context, listen: false).getUser;
    _nameController = TextEditingController(text: user.email);
    _usernameController = TextEditingController(text: user.username);
    _bioController = TextEditingController(text: user.bio);

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void onUpoadPress() async {
    return await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(14),
            // title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                child: const Text(
                  'Take a photo',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                child: const Text(
                  'Select from gallery',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    models.User user =
        Provider.of<UserProvider>(context, listen: false).getUser;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
                size: 35,
              )),
          title: const Text(
            'Edit profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  String res = await FirestoreStorage().updateUserData(
                      username: _usernameController.text,
                      bio: _bioController.text,
                      profilePicFile: _file);
                  Provider.of<UserProvider>(context, listen: false)
                      .refreshUser();
                  Navigator.of(context).pop();
                  showSnackBar(context, 'Profile Updated!');
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.lightBlueAccent,
                  size: 35,
                ))
          ]),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: _file == null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(user.profileUrl),
                      radius: 64,
                    )
                  : CircleAvatar(
                      backgroundImage: MemoryImage(_file!),
                      radius: 64,
                    ),
            ),
            Center(
                child: TextButton(
                    onPressed: onUpoadPress,
                    child: const Text(
                      'Edit profile picture',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent),
                    ))),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(label: Text('Email')),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(label: Text('Username')),
            ),
            TextFormField(
              controller: _bioController,
              decoration: InputDecoration(label: Text('Bio')),
            ),
            SizedBox(
              height: 64,
            ),
            Divider(
              thickness: 2,
              color: Colors.grey[850],
            ),
            TextButton(
                onPressed: () {
                  showSnackBar(
                      context, 'if you still use facebook, delete this app');
                },
                child: Text(
                  'Connected Facebook Page',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      showSnackBar(context,
                          'if you still use facebook, delete this app');
                    },
                    child: Text(
                      'Page',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            Divider(
              height: 40,
              thickness: 2,
              color: Colors.grey[850],
            ),
            Text(
              'Switch to professional account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Divider(
              height: 40,
              thickness: 2,
              color: Colors.grey[850],
            ),
            Text(
              'Personal information settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Divider(
              height: 40,
              thickness: 2,
              color: Colors.grey[850],
            ),
          ],
        ),
      )),
    );
  }
}
