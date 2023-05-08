import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etms_attachment_project/model/user_model.dart';
//import 'package:etms_attachment_project/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'dart:js';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();
  TextEditingController secondName = new TextEditingController();

  String? initialName;
  String? initialSecondname;
  String? initialEmail;
  String? initialPhone;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    initialName = loggedInUser.firstName.toString();
    initialSecondname = loggedInUser.secondName.toString();
    initialEmail = loggedInUser.email.toString();
    initialPhone = loggedInUser.phoneNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Name: ${loggedInUser.firstName} ${loggedInUser.secondName}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Email: ${loggedInUser.email}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "PhoneNumber: ${loggedInUser.phoneNumber}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print(loggedInUser.email);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Edit Profile'),
                        content: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              TextFormField(
                                initialValue: loggedInUser.firstName,
                                onChanged: (value) {
                                  initialName = value;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Firstname',
                                ),
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                initialValue: loggedInUser.secondName,
                                onChanged: (value) {
                                  initialSecondname = value;
                                },
                                decoration: InputDecoration(
                                  labelText: 'SecondName',
                                ),
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                initialValue: loggedInUser.email,
                                onChanged: (value) {
                                  initialEmail = value;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                ),
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                initialValue: loggedInUser.phoneNumber,
                                onChanged: (value) {
                                  initialPhone = value;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Phone',
                                ),
                              ),
                            ],
                          )),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Save'),
                            onPressed: () {
                              // Save the form data here
                              final docUser = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user!.uid);
                              docUser.update({
                                'firstName': initialName,
                                'secondName': initialSecondname,
                                'email': initialEmail,
                                'phoneNumber': initialPhone,
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Edit Profile'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();
  TextEditingController secondName = new TextEditingController();

  String? initialName;
  String? initialSecondname;
  String? initialEmail;
  String? initialPhone;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    initialName = loggedInUser.firstName.toString();
    initialSecondname = loggedInUser.secondName.toString();
    initialEmail = loggedInUser.email.toString();
    initialPhone = loggedInUser.phoneNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            CircleAvatar(
              radius: 70.0,
              backgroundImage: AssetImage('assets/etms.png'),
            ),
            SizedBox(height: 20.0),
            Text(
              "${loggedInUser.firstName} ${loggedInUser.secondName}",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Card(
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 25.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${loggedInUser.email}",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${loggedInUser.phoneNumber}",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Edit Profile'),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: SingleChildScrollView(
                            child: Column(
                          children: [
                            TextFormField(
                              initialValue: initialName,
                              onChanged: (value) {
                                initialName = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Firstname',
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              initialValue: initialSecondname,
                              onChanged: (value) {
                                initialSecondname = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'SecondName',
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              initialValue: initialEmail,
                              onChanged: (value) {
                                initialEmail = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              initialValue: initialPhone,
                              onChanged: (value) {
                                initialPhone = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Phone',
                              ),
                            ),
                          ],
                        )),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Save'),
                          onPressed: () {
                            // Save the form data here
                            final docUser = FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid);
                            docUser.update({
                              'firstName': initialName,
                              'secondName': initialSecondname,
                              'email': initialEmail,
                              'phoneNumber': initialPhone,
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Edit Profile'),
            )
          ],
        ),
      ),
    );
  }
}*/
