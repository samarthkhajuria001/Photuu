import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photuu/providers/user_providers.dart';
import 'package:photuu/services/auth_services.dart';
import 'package:photuu/services/storage/firestore_methods.dart';
import 'package:photuu/utils/colors.dart';
import 'package:photuu/utils/constants.dart';
import 'package:photuu/utils/utils.dart';
import 'package:photuu/widgets/post_card.dart';
import 'package:photuu/models/user.dart' as models;
import 'package:provider/provider.dart';

import '../widgets/textfield_input.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Uint8List? _file;
  late TextEditingController _descriptionController;
  @override
  void initState() {
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void onUpoadPress(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(14),
            title: const Text('Create a Post'),
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

  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    models.User user =
        Provider.of<UserProvider>(context, listen: false).getUser;
    return _file == null
        ? Scaffold(
            body: Center(
              child: IconButton(
                onPressed: () => onUpoadPress(context),
                icon: Icon(Icons.upload_sharp),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _file = null;
                  });
                },
                icon: Icon(Icons.arrow_back),
              ),
              title: const Text('New Post'),
              actions: [
                TextButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          _isloading = true;
                        });
                        String res = await FirestoreStorage().createPost(
                            user: user,
                            file: _file!,
                            description: _descriptionController.text);
                        if (mounted) {
                          Provider.of<UserProvider>(context, listen: false)
                              .refreshUser();
                        }

                        setState(() {
                          _isloading = false;
                          _file = null;
                          _descriptionController.clear();
                        });
                        showSnackBar(context, 'Posted');
                      } catch (err) {
                        showSnackBar(context, err.toString());
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Post',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                children: [
                  _isloading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.all(0)),
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(networkImage),
                        radius: 22,
                      ),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextFieldInput(
                              controller: _descriptionController,
                              textInputType: TextInputType.text,
                              isPassword: false,
                              hintText: 'Description...',
                              maxlines: 8,
                            )),
                      ),
                      Container(
                        height: 45,
                        width: 45,
                        child: Image.memory(
                          _file!,
                          fit: BoxFit.cover,
                          alignment: FractionalOffset.topCenter,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
