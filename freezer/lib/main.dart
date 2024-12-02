import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

Future<void> main() async {
  runApp(driver);
}

get fakeClubId => "1094";

get fakeNationalId => "1";

final ModularApp driver = ModularApp(
  module: WrapperModule(),
  child: const SafeArea(child: MyApp()),
);

class WrapperModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/home',
          child: (context, args) => Scaffold(
              body: SingleChildScrollView(
            child: Column(
              children: List<Widget>.generate(
                1000,
                (index) => Text('this is home dummy text index $index'),
              ),
            ),
          )),
        ),
        ChildRoute(
          '/profile',
          child: (context, args) => Scaffold(
              body: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
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
        )
      ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Home',
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      debugShowCheckedModeBanner: false,
    );
  }
}
