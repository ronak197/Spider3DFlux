import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firestore_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FirestorePage(),
    );
  }
}

class FirestorePage extends StatefulWidget {
  const FirestorePage({Key? key}) : super(key: key);

  @override
  _FirestorePageState createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  CollectionReference thingi = FirebaseFirestore.instance.collection('thingi');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: [
      const SizedBox(
        height: 100,
      ),
      const TextButton(
        onPressed: addUser,
        child: Text(
          "Add User",
        ),
      ),
      ElevatedButton(
          onPressed: () async {
            await getUser();
          },
          child: const Text('Get'))
    ])));
  }
}

CollectionReference thingi = FirebaseFirestore.instance.collection('thingi');

Future<void> getUser() async {
  var _users = await thingi.get();
  print(_users.docs.length);
  print(_users.docs.first.data());
  print(_users.docs.first.get('full_name'));
}

Future<void> addUser() {
  // Call the user's CollectionReference to add a new user
  return thingi
      .add({
        'full_name': 'xxx', // John Doe
        'company': 'company', // Stokes and Sons
        'age': 'age' // 42
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

Future<void> updateUser() {
  return thingi
      .doc('ABC123')
      .update({'info.address.zipcode': 90210})
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
}

Future<void> addCustomUser() {
  return thingi
      // existing document in 'users' collection: "ABC123"
      .doc('ABC123')
      .set(
    {'full_name': "Mary Jane", 'age': 16},
    SetOptions(merge: true),
  ).then((value) {
    print("'full_name' & 'age' merged with existing data!");
  }).catchError((error) => print("Failed to merge data: $error"));
}
