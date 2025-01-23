// import 'dart:io';
// import 'dart:math';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../model/chat_model.dart';
// import '../model/user_model.dart';
//
// class ChatProvider with ChangeNotifier {
//   final TextEditingController chatController = TextEditingController();
//   final String chatHint = "Message";
//   var chatList = <ChatModel>[];
//   var userList = <UserModel>[];
//   final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
//   File? image;
//   final FirebaseStorage storageRef = FirebaseStorage.instance;
//
//
//   // Get chat list from Firebase Realtime Database
//   void getChatList({required String cid, required String otherId}) {
//     var chatId = getChatId(cid: cid, otherId: otherId);
//
//     FirebaseDatabase.instance.ref('messages/$chatId').onValue.listen((event) {
//       chatList.clear();
//       for (var element in event.snapshot.children) {
//         var chat = ChatModel(
//           senderId: element.child("senderId").value.toString(),
//           receiverId: element.child("receiverId").value.toString(),
//           message: element.child("message").value.toString(),
//           status: element.child("status").value.toString(),
//             message_type: element.child("message_type").value.toString(),
//             photo_url: element.child("photo_url").value.toString(),
//
//           // dateTime
//           dateTime: element.child("dateTime").value != null
//               ? DateTime.parse(element.child("dateTime").value.toString())
//               : null,
//         );
//         chatList.add(chat);
//       }
//       notifyListeners();
//     });
//   }
//
//   void sendChat({required String otherUid})async {
//     var chatId = getChatId(cid: uid, otherId: otherUid);
//     var timestamp = DateTime.now().toIso8601String();
//
//     String? imageUrl;
//
//     if(image != null){
//       imageUrl = await uploadFile(image: image!);
//     }
//
//     var data = ChatModel(
//         senderId: uid,
//         receiverId: otherUid,
//         message: chatController.text,
//         status: 'send',
//         photo_url: imageUrl.toString(),
//         message_type: ''
//
//     );
//
//     // var chatMessage = {
//     //   'senderId': uid,
//     //   'receiverId': otherUid,
//     //   'message': chatController.text,
//     //   'status': 'sent',
//     //   'dateTime': timestamp,
//     // };
//
//      await FirebaseDatabase.instance.ref('messages/$chatId').push().set(data.toJson());
//
//     image = null;
//     chatController.clear();
//   }
//
//   String generateRandomString(int len) {
//     const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
//     return String.fromCharCodes(
//       Iterable.generate(len, (_) => chars.codeUnitAt(Random().nextInt(chars.length))),
//     );
//   }
//
//   String getChatId({required String cid, required String otherId}) {
//     return cid.compareTo(otherId) > 0 ? "${cid}$otherId" : "${otherId}$cid";
//   }
//
//   void getUserList() {
//     FirebaseDatabase.instance.ref('users').onValue.listen((event) {
//       userList.clear();
//       for (var element in event.snapshot.children) {
//         var user = UserModel(
//           id: element.child("id").value.toString(),
//           name: element.child("name").value.toString(),
//           email: element.child("email").value.toString(),
//           password: element.child("password").value.toString(),
//         );
//         userList.add(user);
//       }
//       notifyListeners();
//       });
//     }
//
//   Future<void> pickerImageWithCamera() async {
//     try {
//       final pickerFile =
//       await ImagePicker().pickImage(source: ImageSource.camera);
//       if (pickerFile != null) {
//         image = File(pickerFile.path);
//         // setState(() {
//         //   image = File(pickerFile.path);
//         // });
//         // uploadFile();
//       }
//     } catch (e) {
//       print('Error picker image:$e');
//     }
//   }
//
//   Future<void> pickerImageWithGallery() async {
//     try {
//       final pickerFile =
//       await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (pickerFile != null) {
//         image = File(pickerFile.path);
//         // uploadFile();
//       }
//     } catch (e) {
//       print('Error picker image:$e');
//     }
//   }
//
//
//   Future<String> uploadFile({required File image}) async {
//          var ref = storageRef.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}.jpg');
//         await ref.putFile(image!);
//       return await ref.getDownloadURL();
//
//   }
//
//
//   void clearImage(){
//     image = null;
//     notifyListeners();
//    }
//   // void sendImageChat({required String otherUid, required String photoUrl}) {
//   //   var chatId = getChatId(cid: uid, otherId: otherUid);
//   //   var timestamp = DateTime.now().toIso8601String();
//   //
//   //   var chatMessage = {
//   //     'senderId': uid,
//   //     'receiverId': otherUid,
//   //     'message': '',
//   //     'status': 'sent',
//   //     'dateTime': timestamp,
//   //     'message_type': 'image',
//   //     'photo_url': photoUrl,
//   //   };
//   //
//   //   FirebaseDatabase.instance.ref('messages/$chatId').push().set(chatMessage);
//   // }
//
//   Future<void> alertDialogShow(BuildContext context) async {
//     return showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           actions: [
//             const SizedBox(
//               height: 30,
//             ),
//             Center(
//                 child: Text(
//                   'Show Dialog',
//                   style: TextStyle(
//                       fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
//                 )),
//             SizedBox(
//               height: 50,
//             ),
//             Row(
//               children: [
//                 SizedBox(
//                   width: 40,
//                 ),
//                 OutlinedButton(
//                     onPressed: () {
//                       pickerImageWithGallery();
//                       Navigator.pop(context);
//                     },
//                     child: Text(
//                       'gallery',
//                       style: TextStyle(
//                           fontStyle: FontStyle.italic,
//                           fontWeight: FontWeight.bold),
//                     )),
//                 Spacer(),
//                 OutlinedButton(
//                     onPressed: () {
//                       pickerImageWithCamera();
//                       Navigator.pop(context);
//                     },
//                     child: Text(
//                       'Camera',
//                       style: TextStyle(
//                           fontStyle: FontStyle.italic,
//                           fontWeight: FontWeight.bold),
//                     )),
//                 SizedBox(
//                   width: 40,
//                 ),
//               ],
//             )
//           ],
//         );
//       },
//     );
//   }
//
//
// }


import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../model/chat_model.dart';

class ChatViewModel with ChangeNotifier {
  final TextEditingController chatController = TextEditingController();
  var chatList = <ChatModel>[];
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

  Future<void> getChatList({required String cid, required String otherId}) async {
    var chatId = getChatId(cid: cid, otherId: otherId);
    DatabaseReference chatRef =
    FirebaseDatabase.instance.ref('messages/$chatId');
    chatRef.orderByChild("dateTime").onValue.listen((event) {
      chatList.clear();
      var data = event.snapshot.children;
      for (var element in data) {
        var chat = ChatModel.fromJson(Map<String, dynamic>.from(
            element.value as Map<dynamic, dynamic>));
        chatList.add(chat);
      }
      notifyListeners();
    });
  }

  Future<void> sendChat({required String otherUid,required String message, String? imageUrl}) async {
    var chatId = getChatId(cid: uid, otherId: otherUid);
    var randomId = generateRandomString(40);
    DatabaseReference chatRef =
    FirebaseDatabase.instance.ref('messages/$chatId');

    var messageType = imageUrl != null ? "image" : "text";
    var messageData = ChatModel(
      message: imageUrl == null ? chatController.text.trim() : null,
      senderId: uid,
      receiverId: otherUid,
      status: "sent",
      photo_url: imageUrl,
      message_type: messageType,
      dateTime: DateTime.now(),
    );

    await chatRef.child(randomId).set(messageData.toJson());
    if (imageUrl == null) chatController.clear();
    notifyListeners();
  }

  String generateRandomString(int len) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[Random().nextInt(chars.length)])
        .join();
  }

  String getChatId({required String cid, required String otherId}) {
    return cid.compareTo(otherId) > 0 ? "${cid}_$otherId" : "${otherId}_$cid";
  }

  String formatDateTimeToIST(DateTime dateTime) {
    DateTime istDateTime = dateTime.toUtc().add(const Duration(hours: 5, minutes: 30));
    return "${istDateTime.hour % 12 == 0 ? 12 : istDateTime.hour % 12}:${istDateTime.minute.toString().padLeft(2, '0')} ${istDateTime.hour >= 12 ? "PM" : "AM"}";
  }

}
