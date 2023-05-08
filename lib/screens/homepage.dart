import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etms_attachment_project/screens/manage_buses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:etms_attachment_project/screens/profile.dart';
import 'package:etms_attachment_project/screens/routes.dart';
import 'package:etms_attachment_project/screens/login_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

//import 'dart:js';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = 'Null, Press Button';
  String Address = 'search';

  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  //late final double _latitude; // replace with actual latitude
  //late final double _longitude; // replace with actual longitude
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final time = Timestamp.now();
  late final double mylatitude;
  late final double mylongitude;

  /*Future<void> getCoordinates() async {
    List<Location> locations =
        await locationFromAddress("Gronausestraat 710, Enschede");

    // Do something with the locations, such as retrieving the first location's latitude and longitude
    double mylatitude = locations[0].latitude;
    double mylongitude = locations[0].longitude;
    print(mylatitude);
    print(mylongitude);
  }*/

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.openLocationSettings();

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemark);
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  //late Database db;

  List docCrimes = [];
  List docMissing = [];
  List docComplaints = [];

  final TextEditingController currentLocationController =
      TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController pickupTimeController = TextEditingController();
  final TextEditingController dropoffTimeController = TextEditingController();

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          elevation: 2.0,
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white70,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              ListTile(
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
              ),
              ListTile(
                title: const Text('Manage Buses'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ManageBuses()),
                  );
                },
              ),
              ListTile(
                title: const Text('Logout'),
                onTap: () {
                  logout(context);

                  // navigate to login page
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('ETMS'),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Color.fromARGB(179, 235, 229, 229),
            tabs: [
              Tab(text: 'Home'),
              //Tab(text: 'Profile'),
              Tab(text: 'Routes'),
              Tab(text: 'About'),
            ],
          ),
          actions: const <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.search,
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            Center(
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Employee Transport Management System'),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          'Welcome!',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Coordinates points',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          location,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'ADDRESS',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '${Address}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                            onPressed: () async {
                              Position pos = await _determinePosition();
                              print(pos.latitude);
                              location =
                                  'Lat: ${pos.latitude}, Long: ${pos.longitude}';
                              //GetAddressFromLatLong(pos);
                              setState(() {});
                            },
                            child: Text('Get Location')),
                        SizedBox(
                          height: 18,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _destinationController,
                                decoration: InputDecoration(
                                  labelText: 'Destination',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                keyboardType: TextInputType.datetime,
                                controller: pickupTimeController,
                                decoration: InputDecoration(
                                  labelText: 'Pickup Time',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter details';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                keyboardType: TextInputType.datetime,
                                controller: dropoffTimeController,
                                decoration: InputDecoration(
                                  labelText: 'Dropoff Time',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter details';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () async {
                                  //getCoordinates();
                                  mylatitude = -18.019782;
                                  mylongitude = 31.067907;

                                  Position mypos = await _determinePosition();
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    //final destination = _destinationController.text;
                                    _saveDetails(
                                        _destinationController.text,
                                        mypos.latitude,
                                        mypos.longitude,
                                        mylatitude,
                                        mylongitude);
                                  }
                                  // Implement dynamic algorithm here
                                  print(
                                      'Current Location: ${currentLocationController.text}');
                                  print(
                                      'Destination: ${destinationController.text}');
                                  print(
                                      'Pickup Time: ${pickupTimeController.text}');
                                  print(
                                      'Dropoff Time: ${dropoffTimeController.text}');
                                },
                                child: Text('Submit'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ), // home content here.
            const Routes(),
            Profile(),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDetails(String destination, double latitude,
      double longitude, double latitude2, double longitude2) async {
    try {
      await FirebaseFirestore.instance.collection('routes').add({
        'start_location': GeoPoint(latitude, longitude),
        'end_location': GeoPoint(latitude2, longitude2),
        'userID': userID,
        'timestamp': time,
      });
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Details saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Error saving details')),
      );
    }
  }
}
