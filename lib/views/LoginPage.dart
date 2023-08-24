import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:notebook/views/Notebook.dart';
import 'package:appwrite/appwrite.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorMessage = "";
  int errorType = 0;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? username = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Username:"),
              controller: usernameController,
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(hintText: "Password:"),
              controller: passwordController,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          try {
                            UserCredential session = await login(
                                usernameController.value.text,
                                passwordController.value.text);
                            username = usernameController.value.text;
                            setState(() {
                              errorType = 1;
                              errorMessage = "Login Succesful!";
                            });
                            await Future.delayed(Duration(seconds: 2));
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return Notebook(username: username!);
                            }));
                          } on FirebaseAuthException catch (err) {
                            setState(() {
                              errorType = 0;
                              errorMessage = err.message.toString();
                            });
                          }
                        },
                        child: Text("Login")),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          UserCredential newUser = await register(
                              usernameController.value.text,
                              passwordController.value.text);
                          setState(() {
                            errorType = 1;
                            errorMessage = "Succesfully created new user";
                          });
                          usernameController.clear();
                          passwordController.clear();
                        } on FirebaseAuthException catch (err) {
                          setState(() {
                            errorType = 0;
                            errorMessage = err.message.toString();
                          });
                        }
                      },
                      child: Text("Register"))
                ],
              ),
            ),
            Text(errorMessage,
                style: TextStyle(
                    color: errorType == 0 ? Colors.red : Colors.green))
          ],
        ),
      )),
    );
  }
}

Future<UserCredential> login(String username, String password) async {
  return await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: username, password: password);
}

Future<UserCredential> register(String username, String password) async {
  UserCredential user = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: username, password: password);
  return user;
}
