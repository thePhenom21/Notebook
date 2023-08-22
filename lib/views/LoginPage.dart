import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:binary/binary.dart';
import 'package:notebook/views/Notebook.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                          username = await login(usernameController.value.text,
                              passwordController.value.text);
                          if (username == "") {
                            print("No user found");
                          } else {
                            usernameController.clear();
                            passwordController.clear();
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return Notebook(username: username!);
                            }));
                          }
                        },
                        child: Text("Login")),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        username = await register(usernameController.value.text,
                            passwordController.value.text);
                        if (username != null) {
                          usernameController.clear();
                          passwordController.clear();
                        }
                      },
                      child: Text("Register"))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

Future<String?> login(String username, String password) async {
  String payload = passEncode(password);
  try {
    return await Dio()
        .post("http://localhost:8081/login/$username/$payload")
        .then((value) => value.data);
  } catch (err) {
    return null;
  }
}

register(String username, String password) async {
  String payload = passEncode(password);
  try {
    return Dio()
        .post("http://localhost:8081/register/$username/$payload")
        .then((value) => value.data);
  } catch (err) {
    return null;
  }
}

passEncode(String password) {
  String pass_secret = password;
  String payload = "";
  for (int i in pass_secret.runes) {
    payload += "${i.rotateRightShift(20, 32)}k";
  }
  print("Payload: $payload");
  return payload;
}
