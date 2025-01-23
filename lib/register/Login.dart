// import 'package:chat/provider/userProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
//
// import '../provider/chatProvider.dart';
//
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   bool isLoginMode = false;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       Provider.of<UserProvider>(context, listen: false)
//           .checkUserLoginStatus(context);
//       Provider.of<ChatProvider>(context, listen: false).getUserList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var viewModel = Provider.of<UserProvider>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.orange,
//         title: Text(
//           isLoginMode ? "Login" : "Register",
//           style: TextStyle(color: Colors.white, fontSize: 24),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(isLoginMode
//                       ? "Login to your account:"
//                       : "Register your account:",
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 16),
//                 if (!isLoginMode)
//                   showInputField(
//                     controller: viewModel.nameController,
//                     hint: "Enter your name",
//                     icon: Icons.person,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Name is required";
//                       }
//                       return null;
//                     },
//                   ),
//                 showInputField(
//                   controller: viewModel.emailController,
//                   hint: "Enter your email",
//                   icon: Icons.email,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Email is required";
//                     }
//                     if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
//                       return "Enter a valid email";
//                     }
//                     return null;
//                   },
//                 ),
//                 showInputField(
//                   controller: viewModel.passwordController,
//                   hint: "Enter your password",
//                   icon: Icons.lock,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Password is required";
//                     }
//                     if (value.length < 6) {
//                       return "Password must be at least 6 characters long";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     if (isLoginMode)
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             isLoginMode = false;
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 30,
//                             vertical: 12,
//                           ),
//                         ),
//                         child: Text(
//                           "Register",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                     if (!isLoginMode)
//                       ElevatedButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             viewModel.registerNow(context);
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 30,
//                             vertical: 12,
//                           ),
//                         ),
//                         child: const Text(
//                           "Register",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         if (isLoginMode) {
//                           if (_formKey.currentState!.validate()) {
//                             bool isSuccess = await viewModel.loginNow(context);
//                             if (isSuccess) {
//                               Fluttertoast.showToast(msg: "Login successfully");
//                             } else {
//                               Fluttertoast.showToast(msg: "Login failed");
//                             }
//                           }
//                         } else {
//                           setState(() {
//                             isLoginMode = true;
//                           });
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 30,
//                           vertical: 12,
//                         ),
//                       ),
//                       child: Text(
//                         isLoginMode ? "Login" : "Login",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// Widget showInputField({
//   required TextEditingController controller,
//   required String hint,
//   required IconData icon,
//   String? Function(String?)? validator,
// }) {
//   return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
//             prefixIcon: Icon(icon, color: Colors.blueAccent),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//               borderSide: BorderSide(color: Colors.grey),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//               borderSide: BorderSide(color: Colors.blueAccent),
//             ),
//           ),
//           validator: validator,
//           style: TextStyle(fontSize: 16),
//           ),
//       );
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/userProvider.dart';
import 'SingUp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main Container
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: provider.emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: provider.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        provider.userLogin(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: const Center(
                child: Text(
                  "Welcome Back!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
