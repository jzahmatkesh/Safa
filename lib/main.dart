import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/module/MyProvider.dart';
import 'src/module/class.dart';
import 'src/screens/Dashboard.dart';
import 'src/screens/Login.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MyProvider()),
    ],
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'حسابداری رایگان صفا',
      debugShowCheckedModeBanner: false,
      theme: context.watch<MyProvider>().themeData,
      home: MyHome()
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: context.watch<MyProvider>().userStream$,
      builder: (context, user){
        if (user.hasData && user.data.id > 0)              
          return Dashboard();
        return Login();
      },
    );
  }
}