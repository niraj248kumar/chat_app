
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/userProvider.dart';
import '../view/home_page.dart';


class ProfileScreen extends StatelessWidget {
  final String name;
  final String email;
  final currentUser = FirebaseAuth.instance.currentUser;

   ProfileScreen({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserViewModel>(context);
    var heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profiles Screen'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    uid: "",
                  ),
                ));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                var users = provider.userData[index];
                return ListTile(
                  title: SizedBox(
                    height:heightScreen * 0.5,
                    child: Card(
                      color: Colors.white10,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          CircleAvatar(
                            radius: 45,
                            child: Icon(Icons.person),
                          ),
                          Text(
                            "Name: ${users.name}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.lightBlue[900],
                                fontStyle: FontStyle.italic),
                          ),
                          Text(
                            "    Email: ${users.email}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.lightBlue[900],
                                fontStyle: FontStyle.italic),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              color: Colors.lightBlue,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text('User LogOut',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.lightBlue[900],
                                      fontStyle: FontStyle.italic)),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  provider.logoutUser(context);
                                },
                                child: Icon(Icons.logout),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text('User Chat History',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.lightBlue[900],
                                      fontStyle: FontStyle.italic)),
                              Spacer(),
                              InkWell(
                                onTap: () {},
                                child: Icon(Icons.history),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );

              },
            ),
          ),
        ],
      ),
    );
  }


}
