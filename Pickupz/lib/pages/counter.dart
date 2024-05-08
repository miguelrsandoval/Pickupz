import 'package:flutter/material.dart';
import 'counter_widget.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pickup Games'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCounter(eventNameText: 'Wrec', counterFieldName: 'wrec', eventDocument: 'wrec',),
            CustomCounter(eventNameText: 'Park', counterFieldName: 'park', eventDocument: 'park',),
            CustomCounter(eventNameText: 'Court', counterFieldName: 'court', eventDocument: 'court',),
          ],
        ),
      ),
    );
  }
}
