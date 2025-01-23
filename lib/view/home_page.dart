// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../profile/profile_screen.dart';
// import '../provider/chatProvider.dart';
// import 'chat_page.dart';
//
// class HomePage extends StatelessWidget {
//   final String uid;
//
//   const HomePage({super.key, required this.uid});
//
//   @override
//   Widget build(BuildContext context) {
//     var mq = MediaQuery.sizeOf(context);
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.blue,
//         title: const Text(
//           "Conversation",
//           style: TextStyle(
//               color: Colors.white, fontSize: 24, fontStyle: FontStyle.italic),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               var viewModel = Provider.of<ChatProvider>(context, listen: false);
//               if (viewModel.userList.isNotEmpty) {
//                 var currentUser = viewModel.userList[0];
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProfileScreen(
//                       name: currentUser.name,
//                       email: currentUser.email,
//                     ),
//                   ),
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("No user data available")),
//                 );
//               }
//             },
//             icon: const Icon(
//               Icons.person,
//               color: Colors.white,
//               size: 30,
//             ),
//           ),
//         ],
//       ),
//       body: Consumer<ChatProvider>(
//         builder: (context, viewModel, child) {
//           if (viewModel.userList.isEmpty) {
//             return const Center(child: Text("No users available"));
//           }
//           return ListView.builder(
//             itemCount: viewModel.userList.length,
//             itemBuilder: (context, index) {
//               var user = viewModel.userList[index];
//               return ListTile(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ChatPage(
//                           otherUid: user.id,
//                           name: user.name,
//                         ),
//                       ),
//                     );
//                   },
//                   title: Card(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50)),
//                     color: Colors.lightBlue[200],
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           width: 10,
//                         ),
//                         CircleAvatar(
//                           radius: 20,
//                           child: Center(
//                               child: Text(
//                             user.name[0].toUpperCase(),
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           )),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(user.name,
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold)),
//                             Text(user.email,
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   )
//
//                   // Text(user.name),
//                   // subtitle: Text(user.email),
//                   // leading: CircleAvatar(
//                   //   child: Text(user.name[0].toUpperCase()),
//                   // ),
//                   );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../profile/profile_screen.dart';
import '../provider/userProvider.dart';
import 'chat_page.dart';


class HomePage extends StatefulWidget {
  final String uid;

  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UserViewModel>(context, listen: false)
          .fetchUserData(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          "Chat Home",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(name: "Name", email: "Email")));
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
                size: 34,
              )),
        ],
      ),
      body: Consumer<UserViewModel>(
        builder: (context, userProvider, child) {
          int  itemCount = userProvider.userData.length>1?userProvider.userData.length-1:0;
          if (userProvider.isLoding) {
            return Center(child: CircularProgressIndicator());
          } else if (userProvider.userData.isEmpty) {
            return Center(child: Text("No users found"));
          } else {

            return ListView.builder(
              itemCount:userProvider.userData.length,
              itemBuilder: (context, index) {
                var user = userProvider.userData[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          otherUid: user.id.toString(),
                          otherName: user.name.toString(),
                        ),
                      ),
                          (route) => false,
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text("${user.name}"),
                      subtitle: Text("${user.email}"),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}