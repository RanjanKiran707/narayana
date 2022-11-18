import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:narayana/main.dart';
import 'package:narayana/merchant_view.dart';

class MerchantScreen extends StatelessWidget {
  const MerchantScreen({Key? key, required this.creds}) : super(key: key);
  final Map creds;
  showAddDialog(BuildContext context) {
    final ctrl1 = TextEditingController();
    final ctrl2 = TextEditingController();
    Uint8List? image;
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: ctrl1,
                    decoration: const InputDecoration(labelText: "Author Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Cannot be empty";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: ctrl2,
                    decoration: const InputDecoration(labelText: "Price of Book"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Cannot be empty";
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        image = await pickedFile.readAsBytes();
                        debugPrint("Length : ${image!.length}");
                      }
                    },
                    child: const Text("Pick Image"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pick an Image")));
                        return;
                      }
                      if (formKey.currentState!.validate()) {
                        Map formValues = {
                          "author": ctrl1.text,
                          "price": ctrl2.text,
                          "image": image,
                          "creds": creds,
                        };

                        await Hive.box("books").add(formValues);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Add"),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: 20,
            children: [
              ElevatedButton(onPressed: () {}, child: const Text("Orders")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(createRoute(MerchantBooks(creds: creds)));
                  },
                  child: const Text("View")),
              ElevatedButton(
                  onPressed: () {
                    showAddDialog(context);
                  },
                  child: const Text("Add")),
            ],
          ),
        ),
      ),
    );
  }
}
