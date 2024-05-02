import 'package:flutter/material.dart';
import 'package:myapp/pages/auth.dart';
import 'place_search.dart'; 
import 'package:myapp/pages/map.dart';
import 'package:myapp/pages/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
      home: const MyTabs(),
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
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            const MapPage(),
            PlaceListPage(),
            const WidgetTree(),
          ],
        ),
      ),
    );
  }
}
