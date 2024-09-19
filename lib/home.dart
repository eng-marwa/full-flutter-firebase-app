import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:g1d_firebase/model/app_user.dart';
import 'package:g1d_firebase/utils/context_extension.dart';
import 'package:g1d_firebase/utils/file_utils.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.ref();
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance.ref();
  late User _currentUser;
  String picUrl = '';

  @override
  void initState() {
    _currentUser = _auth.currentUser!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () => _logout(context), child: const Text('Logout'))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Home Page'),
            const SizedBox(height: 20),
            if (picUrl.isNotEmpty)
              Image.network(
                picUrl,
                width: 200,
              )
            else
              Container(),
            ElevatedButton(
                onPressed: () => _saveUserData(context),
                child: const Text('Save User Data-> RealTime Db')),
            ElevatedButton(
                onPressed: () => _viewUserData(context),
                child: const Text('View User Data-> RealTime Db')),
            ElevatedButton(
                onPressed: () => _deleteUserData(context),
                child: const Text('Delete User Data-> RealTime Db')),
            Divider(),
            ElevatedButton(
                onPressed: () => _saveFirestoreData(context),
                child: const Text('Save User Data-> Firestore Db')),
            ElevatedButton(
                onPressed: () => _AddUserFriendsData(context),
                child: const Text('Add User Friends Data-> Firestore Db')),
            ElevatedButton(
                onPressed: () => _viewFriends(context),
                child: const Text('View Friends-> Firestore Db')),
            ElevatedButton(
                onPressed: () => _orderFriendsAsc(context),
                child: const Text('Order ASC Friends-> Firestore Db')),
            Divider(),
            ElevatedButton(
                onPressed: () => _uploadPicture(context),
                child: const Text('UploadPicture')),
            ElevatedButton(
                onPressed: () => throw Exception('This is a test exception'),
                child: const Text('throw')),
          ],
        ),
      ),
    );
  }

  _logout(context) async {
    _auth.signOut();
    // Navigator.pushNamed(context, '/login');
    context.navigateTo('/login');
  }

  _saveUserData(BuildContext context) {
    // Save user data to Realtime Database
    AppUser appUser = AppUser(
        _currentUser.uid, _currentUser.email!, 'Marwa Talaat',
        phone: '0158418548');
    try {
      _database
          .child('users')
          .child(_currentUser.uid)
          .set(appUser.toJson())
          .then(
        (value) {
          context.showSnackBar('User Data Saved Successfully');
        },
      );
    } on FirebaseException catch (e) {
      print(e.code);
      print(e.message);
    }
  }

  _viewUserData(BuildContext context) {
    // View user data from Realtime Database
    _database.child('users').child(_currentUser.uid).once().then(
      (DatabaseEvent event) {
        // print(event.snapshot.value);
        // print(event.snapshot.value.runtimeType);
        if (event.snapshot.value != null) {
          Map<String, dynamic> data = Map<String, dynamic>.from(
              event.snapshot.value as Map<Object?, Object?>);

          AppUser _user = AppUser.fromJson(data);
          setState(() {
            picUrl = _user.photoUrl!;
          });
          context.showSnackBar('Welcome ${_user.name}');
        }
      },
    );
  }

  _deleteUserData(BuildContext context) {
    // Delete user data from Realtime Database
    _database.child('users').child(_currentUser.uid).remove().then(
      (value) {
        context.showSnackBar('User Data Deleted Successfully');
      },
    );
  }

  _saveFirestoreData(BuildContext context) {
    AppUser appUser = AppUser(
        _currentUser.uid, _currentUser.email!, 'Marwa Talaat',
        phone: '0158418548');

    try {
      _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .set(appUser.toJson())
          .then(
        (value) {
          context.showSnackBar('User Data Saved Successfully');
        },
      );
    } on FirebaseException catch (e) {
      print(e.code);
      print(e.message);
    }
  }

  _viewFirestoreData(BuildContext context) {}

  _deleteFirestoreData(BuildContext context) {}

  _AddUserFriendsData(BuildContext context) {
    _firestore
        .collection('users')
        .doc(_currentUser.uid)
        .collection('friends')
        .doc()
        .set(AppUser('8VJwyOY4lSQLEDDRQGsyAOjXj242', 'sara@gmail.com', 'Sara')
            .toJson());
  }

  _viewFriends(BuildContext context) {
    try {
      _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .collection('friends')
          .get()
          .then(
        (QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((e) => print(e.data()));
          // var data = querySnapshot.docs.where(
          //   (element) =>
          //       AppUser.fromJson(element.data() as Map<String, dynamic>)
          //           .name
          //           .startsWith('A'),
          // );
          // print(data.first.data());
        },
      );
    } on FirebaseException catch (e) {
      print(e.code);
      print(e.message);
    }
  }

  _orderFriendsAsc(BuildContext context) {
    _firestore
        .collection('users')
        .doc(_currentUser.uid)
        .collection('friends')
        .orderBy('name')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach(
        (doc) {
          print(doc.data());
        },
      );
    });
  }

  _uploadPicture(BuildContext context) async {
    String? path = await FileUtils.getFileName();
    if (path != null) {
      var name = path.split('/').last;
      File file = File(path);
      _storage
          .child('images')
          .child(_currentUser.uid)
          .child(name)
          .putFile(file)
          .then(
        (TaskSnapshot taskSnapshot) {
          taskSnapshot.ref.getDownloadURL().then(
            (value) {
              setState(() {
                picUrl = value;
                updateDatabase(picUrl);
              });
            },
          );
        },
      );
    }
  }

  void updateDatabase(String picUrl) {
    try {
      _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .update({'photoUrl': picUrl});

      _database
          .child('users')
          .child(_currentUser.uid)
          .update({'photoUrl': picUrl});

      context.showSnackBar('Updated');
    } on FirebaseException catch (e) {
      print(e.code);
      print(e.message);
    }
  }
}
