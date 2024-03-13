import 'package:flutter/material.dart';
import 'package:myapp/pages/map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Fixed the syntax here

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pickupz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 64, 183, 58),
        ),
        useMaterial3: true,
      ),
      home: const MapPage(),
    );
  }
}
