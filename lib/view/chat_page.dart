import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../provider/chatProvider.dart';
import 'home_page.dart';

class ChatScreen extends StatefulWidget {
  final String otherUid;
  final String otherName;

  const ChatScreen({
    super.key,
    required this.otherUid,
    required this.otherName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final uId = FirebaseAuth.instance.currentUser?.uid;
  final ScrollController scrollController = ScrollController();

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    var uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    Future.delayed(
      Duration(seconds: 2),
      () async {
        var viewModel = Provider.of<ChatViewModel>(context, listen: false);
        await viewModel.getChatList(cid: uid, otherId: widget.otherUid);
      },
    );
  }

//Method to pick an image from the gallery
  Future<void> _pickImage() async {

    final picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<String> _uploadImageToFirebase(File imageFile) async {
    String fileName =
        "chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg";
    try {
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Image upload failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var heightScreen = MediaQuery.of(context).size.height;
    var viewModel = Provider.of<ChatViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(uid: ""),
              ),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("images/young.png"),
            ),
            SizedBox(width: 10),
            Text(
              widget.otherName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatViewModel>(
              builder: (context, value, child) {
                if (value.chatList.isEmpty) {
                  return Center(
                    child: Text(
                      "No messages yet",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  );
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount: value.chatList.length,
                  itemBuilder: (context, index) {
                    var user = value.chatList[index];

                    bool designSenderReceiver = user.senderId == uId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Align(
                        alignment: user.senderId == uId
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(

                            color: designSenderReceiver ? Colors.grey : Colors.green,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: designSenderReceiver ? Radius.circular(20) : Radius.zero,
                              bottomRight: designSenderReceiver ? Radius.zero : Radius.circular(20),
                            ),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              user.message_type == "image"
                                  ? Image.network(
                                      user.photo_url ?? "",
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    )
                                  : Text(user.message ?? "",
                                      style: TextStyle(fontSize: 18,color: designSenderReceiver?Colors.white:Colors.black)),
                              Text(user.dateTime != null ? viewModel.formatDateTimeToIST(user.dateTime!) : "Unknown time",
                                  style: TextStyle(fontSize: 14, color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Message Input Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Column(
              children: [
                Positioned(
                    child: Column(
                  children: [
                    if (_selectedImage != null)
                      Stack(
                        children: [
                          Container(
                            color: Colors.white70,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                    height: 200,
                                    width: widthScreen * 0.5,
                                    fit: BoxFit.cover,
                                    _selectedImage!)),
                          ),
                          Positioned(
                              left: 10,
                              top: 20,
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedImage = null;
                                    });
                                  },
                                  child:
                                      Icon(Icons.cancel_presentation_sharp))),
                        ],
                      )
                  ],
                )),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: viewModel.chatController,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: IconButton(
                            onPressed: _pickImage,
                            icon: Icon(Icons.photo, color: Colors.grey[700]),
                          ),
                        ),
                        onChanged: (text) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      onTap: () async {
                        if (viewModel.chatController.text.trim().isNotEmpty ||
                            _selectedImage != null) {
                          String? imageUrl;
                          if (_selectedImage != null) {
                            imageUrl =
                                await _uploadImageToFirebase(_selectedImage!);
                            setState(() {
                              _selectedImage = null;
                            });
                          }
                          viewModel.sendChat(
                              otherUid: widget.otherUid,
                              message: viewModel.chatController.text.trim(),
                              imageUrl: imageUrl);
                          viewModel.chatController.clear();
                          Future.delayed(
                            Duration(milliseconds: 300),
                            () {
                              if (scrollController.hasClients) {
                                scrollController.jumpTo(
                                  scrollController.position.maxScrollExtent,
                                );
                              }
                            },
                          );
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor:
                            (viewModel.chatController.text.trim().isEmpty &&
                                    _selectedImage == null)
                                ? Colors.grey
                                : Colors.blue,
                        radius: 24,
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
