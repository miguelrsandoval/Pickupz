import 'package:flutter/material.dart'; // Import Flutter material package
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth package


class CustomCounter extends StatefulWidget {
  final String eventNameText;
  final String counterFieldName;
  final String eventDocument; // New parameter to specify the event document

  const CustomCounter({
    Key? key,
    required this.eventNameText,
    required this.counterFieldName,
    required this.eventDocument, // Initialize the new parameter
  }) : super(key: key);

  @override
  _CustomCounterState createState() => _CustomCounterState();
}

class _CustomCounterState extends State<CustomCounter> {
  late String _userDocumentId;
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('event').doc(widget.eventDocument).snapshots(),
      builder: (context, eventSnapshot) {
        if (!eventSnapshot.hasData) {
          return CircularProgressIndicator();
        }
        bool eventStarted = eventSnapshot.data!.get('started') ?? false;
        String? eventName = eventSnapshot.data!.get('eventName');
        FirebaseAuth auth = FirebaseAuth.instance;
        User? currentUser = auth.currentUser;
        if (currentUser == null) {
          return Center(
            child: Text("Sign in to See Pickup Games"),
          );
        }
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('counters').doc(widget.counterFieldName).snapshots(),
          builder: (context, counterSnapshot) {
            if (!counterSnapshot.hasData) {
              return CircularProgressIndicator();
            }
            int _counter = counterSnapshot.data!.get('value');print('3'); // Update to read specific event counter
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                bool _userSignedUp = userSnapshot.data!.get('${widget.counterFieldName}SU') ?? false;// Update to read specific event sign-up status
                _userDocumentId = userSnapshot.data!.id;
                _loading = false; // Data is loaded

                if (!eventStarted) {
                  return ElevatedButton(
                    onPressed: () {
                      String? userEmail = currentUser.email;
                      FirebaseFirestore.instance.collection('event').doc(widget.eventDocument).set({
                        'started': true,
                        'eventName': 'Event Started by $userEmail',
                      });
                      FirebaseFirestore.instance.collection('counters').doc(widget.eventDocument).set({
                        'value': 0, // Update to initialize specific event counter
                      });
                      FirebaseFirestore.instance.collection('users').doc(_userDocumentId).update({
                        '${widget.counterFieldName}SU': true, // Update to mark user signed up for specific event
                      });
                    },
                    child: Text('Start Event'),
                  );
                } else {
                  bool currentUserStartedEvent = eventSnapshot.data!.get('eventName')?.contains(currentUser.email) ?? false;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '($eventName) ${widget.eventNameText}:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '$_counter',
                          style: TextStyle(fontSize: 40),
                        ),
                        SizedBox(height: 20),
                        if (!_userSignedUp && !currentUserStartedEvent)
                          ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance.collection('counters').doc(widget.eventDocument).update({
                                'value': _counter + 1, // Update to increment specific event counter
                              });
                              FirebaseFirestore.instance.collection('users').doc(_userDocumentId).update({
                                '${widget.counterFieldName}SU': true, // Update to mark user signed up for specific event
                              });
                            },
                            child: Text('Increment'),
                          ),
                        if (_userSignedUp)
                          Text(
                            'You Signed Up!',
                            style: TextStyle(fontSize: 20),
                          ),
                        if (currentUserStartedEvent)
                          ElevatedButton(
                            onPressed: () {
                              String? userEmail = currentUser.email;
                              FirebaseFirestore.instance.collection('event').doc(widget.eventDocument).update({
                                'started': false,
                                'eventName': 'Event closed by $userEmail',
                              });
                            },
                            child: Text('Close Event'),
                          ),
                      ],
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
