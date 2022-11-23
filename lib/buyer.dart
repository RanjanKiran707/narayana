import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:narayana/main.dart';
import 'package:narayana/merchant_view.dart';
import 'package:velocity_x/velocity_x.dart';

class BuyerScreen extends StatelessWidget {
  const BuyerScreen({Key? key, required this.creds}) : super(key: key);
  final Map creds;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: Wrap(
            direction: Axis.vertical,
            spacing: 20,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(createRoute(MerchantListView(
                      creds: creds,
                    )));
                  },
                  child: const Text("Merchant")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      createRoute(NearScreen(distance: int.parse(creds["distance"]))),
                    );
                  },
                  child: const Text("Near")),
              ElevatedButton(onPressed: () {}, child: const Text("Frequently")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(createRoute(AllBooks(creds: creds)));
                  },
                  child: const Text("All")),
            ],
          ),
        ),
      ),
    );
  }
}

class MerchantListView extends StatelessWidget {
  MerchantListView({Key? key, required this.creds}) : super(key: key);
  final Map creds;

  List people = Hive.box("cred").values.toList();
  @override
  Widget build(BuildContext context) {
    people = people.where((element) => element["type"] == "merchant").toList();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Merchants")),
        body: SizedBox.expand(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final item = people[index];
              return ListTile(
                title: Text(item["fname"] + item["lname"]),
                onTap: () {
                  Navigator.of(context).push(createRoute(MerchantBooks(
                    creds: item,
                    buyerCreds: creds,
                  )));
                },
              );
            },
            itemCount: people.length,
          ),
        ),
      ),
    );
  }
}

class NearScreen extends StatelessWidget {
  NearScreen({Key? key, required this.distance}) : super(key: key);
  final int distance;
  List people = Hive.box("cred").values.toList();

  @override
  Widget build(BuildContext context) {
    people = people.where((element) => element["type"] == "merchant").toList();
    people.sort(
      (a, b) {
        int a1 = int.parse(a["distance"]);
        int a2 = int.parse(b["distance"]);
        a1 = (distance - a1).abs();
        a2 = (distance - a2).abs();
        return a1.compareTo(a2);
      },
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Sorted in Nearest")),
        body: SizedBox.expand(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final item = people[index];
              debugPrint(item["distance"]);
              int diff = int.parse(item["distance"]) - distance;
              diff = diff.abs();
              return ListTile(
                title: Text(item["fname"] + item["lname"]),
                onTap: () {
                  Navigator.of(context).push(createRoute(MerchantBooks(creds: item)));
                },
                subtitle: Text("Distance = $diff"),
              );
            },
            itemCount: people.length,
          ),
        ),
      ),
    );
  }
}

class AllBooks extends StatelessWidget {
  const AllBooks({Key? key, required this.creds}) : super(key: key);
  final Map creds;
  @override
  Widget build(BuildContext context) {
    List list = Hive.box("books").values.toList();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Books")),
        body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final Map item = list[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.memory(item["image"], height: 150),
                      10.heightBox,
                      Text("Author = " + item["author"]),
                      10.heightBox,
                      Text("Price = ${item['price']}"),
                      10.heightBox,
                      Text("Merchant Name : ${item["creds"] != null ? item["creds"]["fname"] : "No Name"}"),
                      10.heightBox,
                      ElevatedButton(
                        onPressed: () {
                          Hive.box("orders").add({
                            "book": item,
                            "buyer": creds,
                            "dateTime": DateTime.now(),
                          });
                          context.showToast(msg: "Succesfully bought");
                        },
                        child: const Text("Buy"),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
