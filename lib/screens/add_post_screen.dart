import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/services/FirestoreService.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;


  void postImage(
      String uid,
      String username,
      String profImage
  ) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreService().uploadPost(
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage
      );
      setState(() {
        isLoading = false;
      });
      if (res == "Success") {
        showSnackBar('Posted', context);
        clearImage();
      } else {
        showSnackBar(res, context);
      }
    } catch(e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  _selectImage(BuildContext context) async {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return showDialog(
        context: context,
        builder: (context) {
          return !isIOS? SimpleDialog(
            title: const Text('Create a Post'),
            children: <Widget>[
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Take a photo'),
                  onPressed: () async {
                    Navigator.pop(context);
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  }),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Choose from Gallery'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  }),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ) : CupertinoAlertDialog(
            title: const Text("Create a post"),
            actions: [
              CupertinoDialogAction(
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              CupertinoDialogAction(
                child: const Text("Choose from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              CupertinoDialogAction(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  void onBackPressed(bool isIos) {
    isIos? showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Are you sure?'),
            content: const Text("If You Go Back The Post Will Be Deleted"),
            actions: [
              CupertinoDialogAction(
                child: const Text("Discard"),
                onPressed: () {
                  setState(() {
                    _file = null;
                    Navigator.pop(context);
                  });
                },
              ),
              CupertinoDialogAction(
                child: const Text("Cancel"),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        }
    ) : showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text("If You Go Back The Post Will Be Deleted"),
            actions: [
              TextButton(
                child: const Text("Discard"),
                onPressed: () {
                  setState(() {
                    _file = null;
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        }
    );
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;


    return _file == null ? Center(
      child: IconButton(
        onPressed: () => _selectImage(context),
        icon: const Icon(Icons.upload_file),
      ),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: Icon(isIOS? Icons.arrow_back_ios_new : Icons.arrow_back),
          onPressed: () => onBackPressed(isIOS),
        ),
        title: const Text("Post to"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextButton(
                onPressed: () => postImage(user!.uid, user.username, user.photoUrl),
                child: const Text(
                  "Post",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
            ),
          )
        ],
      ),
      body: Column(
        children: [
          isLoading? const LinearProgressIndicator(): Container(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.45,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: "Write a captain...",
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter
                      )
                    ),
                  ),
                ),
              ),
              const Divider()
            ],
          )
        ],
      ),
    );
  }
}
