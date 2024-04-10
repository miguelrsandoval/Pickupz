import 'package:flutter/material.dart';
import 'package:myapp/pages/auth.dart';
import 'package:myapp/pages/map.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: const MyTabs(), // Use the MyTabs widget as the home
    );
  }
}

class MyTabs extends StatelessWidget {
  const MyTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pickupz'),
          bottom: const TabBar(
            isScrollable: false,
            tabs: [
              Tab(icon: Icon(Icons.map)),
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.account_circle)), 
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            MapPage(),
            HomePage(),
            Auth(),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('This is the home page'),
      ),
    );
  }
}
