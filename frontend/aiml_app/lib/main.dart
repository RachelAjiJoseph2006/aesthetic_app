import 'package:flutter/material.dart';
import 'pages/homepage_widget.dart';
import 'pages/secondpage_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aesthetic App',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePageWidget(),
        '/second': (context) => const SecondPageWidget(),
      },
    );
  }
}
