import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:narayana/buyer.dart';
import 'package:narayana/main.dart';
import 'package:narayana/merchant.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final ctrl1 = TextEditingController();
  final ctrl2 = TextEditingController();

  login(BuildContext context) {
    List<Map> values = List<Map>.from(Hive.box("cred").values.toList());
    debugPrint(values.toString());
    for (Map value in values) {
      if (value["email"] == ctrl1.text && value["password"] == ctrl2.text) {
        if (value["type"] == "merchant") {
          Navigator.of(context).push(createRoute(MerchantScreen(creds: value)));
        } else {
          Navigator.of(context).push(createRoute(BuyerScreen(creds: value)));
        }
        return;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong Credentials")));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: ctrl1,
                decoration: const InputDecoration(
                  labelText: "UserId/Email",
                ),
              ),
              20.heightBox,
              TextField(
                controller: ctrl2,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
              ),
              30.heightBox,
              ElevatedButton(
                  onPressed: () {
                    login(context);
                  },
                  child: const Text("Login")),
            ],
          ),
        ),
      ),
    );
  }
}
