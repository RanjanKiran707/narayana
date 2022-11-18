import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:velocity_x/velocity_x.dart';

class MerchantBooks extends StatelessWidget {
  MerchantBooks({Key? key, required this.creds}) : super(key: key);
  final Map creds;
  late List list;
  @override
  Widget build(BuildContext context) {
    list = Hive.box("books").values.toList().where((element) => element["creds"] == creds).toList();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Books")),
        body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final Map item = list[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.memory(item["image"], height: 150),
                  10.heightBox,
                  Text("Author = " + item["author"]),
                  10.heightBox,
                  Text("Price = ${item['price']}"),
                  10.heightBox,
                  Text("Merchant Name : ${creds["fname"] + creds["lname"]}"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
