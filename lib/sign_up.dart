import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:narayana/main.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpScreen1 extends StatefulWidget {
  const SignUpScreen1({Key? key}) : super(key: key);

  @override
  State<SignUpScreen1> createState() => _SignUpScreen1State();
}

class _SignUpScreen1State extends State<SignUpScreen1> {
  String? _value;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                hint: const Text("Select a Value"),
                value: _value,
                items: const [
                  DropdownMenuItem(
                    value: "merchant",
                    child: Text("Merchant"),
                  ),
                  DropdownMenuItem(
                    value: "buyer",
                    child: Text("Buyer"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _value = value!;
                  });
                },
              ),
              20.heightBox,
              ElevatedButton(
                  onPressed: () {
                    if (_value == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Choose One to Proceed")));
                      return;
                    }
                    Navigator.of(context).push(createRoute(SignUp2(type: _value!)));
                  },
                  child: const Text("Go Next")),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUp2 extends StatefulWidget {
  const SignUp2({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  final formKey = GlobalKey<FormState>();
  String groupValue = "male";

  Map formValues = {};

  submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await Hive.box("cred").add(formValues);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.type),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox.expand(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: "First Name"),
                      onSaved: (value) {
                        formValues["fname"] = value;
                      },
                      validator: (value) {
                        if (value.isEmptyOrNull) {
                          return "Cannot be empty";
                        }
                        return null;
                      },
                    ),
                    10.heightBox,
                    TextFormField(
                      onSaved: (value) {
                        formValues["lname"] = value;
                      },
                      decoration: const InputDecoration(labelText: "Last Name"),
                      validator: (value) {
                        if (value.isEmptyOrNull) {
                          return "Cannot be empty";
                        }
                        return null;
                      },
                    ),
                    const Text("Enter your Gender"),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: "male",
                              groupValue: groupValue,
                              onChanged: (value) {
                                setState(() {
                                  groupValue = value!;
                                });
                              },
                            ),
                            const Text("Male"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: "female",
                              groupValue: groupValue,
                              onChanged: (value) {
                                setState(() {
                                  groupValue = value!;
                                });
                              },
                            ),
                            const Text("Female"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: "other",
                              groupValue: groupValue,
                              onChanged: (value) {
                                setState(() {
                                  groupValue = value!;
                                });
                              },
                            ),
                            const Text("Other"),
                          ],
                        ),
                      ],
                    ),
                    10.heightBox,
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Email"),
                      onSaved: (value) {
                        formValues["gender"] = groupValue;
                        formValues["type"] = widget.type;
                        formValues["email"] = value;
                      },
                      validator: (value) {
                        if (value.isEmptyOrNull) {
                          return "Cannot be empty";
                        }
                        if (!value!.contains("@")) {
                          return "Enter Valid Email";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Password"),
                      onSaved: (value) {
                        formValues["password"] = value;
                      },
                      validator: (value) {
                        if (value.isEmptyOrNull) {
                          return "Cannot be empty";
                        }

                        return null;
                      },
                    ),
                    10.heightBox,
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        formValues["phone"] = value;
                      },
                      decoration: const InputDecoration(labelText: "Phone"),
                      validator: (value) {
                        if (value.isEmptyOrNull) {
                          return "Cannot be empty";
                        }
                        if (value!.length != 10) {
                          return "Enter 10 digits only";
                        }
                        return null;
                      },
                    ),
                    10.heightBox,
                    TextFormField(
                      onSaved: (value) {
                        formValues["distance"] = value;
                      },
                      decoration: const InputDecoration(labelText: "distance"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmptyOrNull) {
                          return "Cannot be empty";
                        }
                        if (int.tryParse(value!) == null) {
                          return "Enter valid Number";
                        }
                        return null;
                      },
                    ),
                    10.heightBox,
                    ElevatedButton(
                      onPressed: () {
                        submit();
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
