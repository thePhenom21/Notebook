import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(decoration: InputDecoration(hintText: "Username:")),
            TextFormField(
              obscureText: false,
              decoration: InputDecoration(hintText: "Password:"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child:
                        ElevatedButton(onPressed: () {}, child: Text("Login")),
                  ),
                  ElevatedButton(onPressed: () {}, child: Text("Register"))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
