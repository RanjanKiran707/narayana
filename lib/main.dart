import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:narayana/entry_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("cred");
  await Hive.openBox("books");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const EntryPage(),
    );
  }
}

createRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
