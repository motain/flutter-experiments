import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  runApp(MyApp());
}

get fakeClubId => "1094";

get fakeNationalId => "1";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      initialRoute: '/home',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/home': (context) => Scaffold(
                body: SingleChildScrollView(
              child: Column(
                children: List<Widget>.generate(
                  1000,
                  (index) => Text('this is home dummy text index $index'),
                ),
              ),
            )),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/profile': (context) => Scaffold(
                body: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(
                  width: 100,
                  height: 50,
                  child: UiKitView(
                    viewType: "freezer",
                    creationParamsCodec: StandardMessageCodec(),
                  ),
                ),
                ...List<Widget>.generate(
                  1000,
                  (index) => Text('this is profile dummy text index $index'),
                ),
              ]),
            )),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
