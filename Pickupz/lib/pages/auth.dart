import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth{
  final FirebaseAuth _firebaseAuth =  FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  })  async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  })  async {
    try {
      // Create user with email and password
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      // Get the current user after sign up
      User? user = _firebaseAuth.currentUser;

      // Create user document in Firestore
      await _firestore.collection('users').doc(user!.uid).set({
        'wrecSU': false,
        'courtSU': false,
        'parkSU': false,
        // Add any additional user data here
      });
    } catch (e) {
      // Handle any errors
      print('Error creating user: $e');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
