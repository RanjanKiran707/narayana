import 'package:flutter/material.dart';
import 'package:narayana/login.dart';
import 'package:narayana/main.dart';
import 'package:narayana/sign_up.dart';
import 'package:velocity_x/velocity_x.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(createRoute(LoginScreen()));
                },
                child: const Text("Login"),
              ),
              20.heightBox,
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(createRoute(const SignUpScreen1()));
                },
                child: const Text("Sign Up"),
              ),
              30.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
