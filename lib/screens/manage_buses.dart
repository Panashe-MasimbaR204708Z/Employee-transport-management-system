import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'dart:js';

class ManageBuses extends StatefulWidget {
  const ManageBuses({super.key});

  @override
  State<ManageBuses> createState() => _ManageBusesState();
}

class _ManageBusesState extends State<ManageBuses> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController IDController = new TextEditingController();
  TextEditingController modelController = new TextEditingController();
  TextEditingController driverController = new TextEditingController();
  TextEditingController capacityController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();

  Widget _buildID() {
    return TextFormField(
      controller: IDController,
      maxLength: 50,
      decoration: InputDecoration(
        labelText: 'ID',
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.green),
        ),
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget _buildModel() {
    return TextFormField(
      controller: modelController,
      maxLength: 30,
      decoration: InputDecoration(
        labelText: 'Model',
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.green),
        ),
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget _buildDriver() {
    return TextFormField(
      controller: driverController,
      maxLength: 10,
      decoration: InputDecoration(
        labelText: 'Driver',
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.green),
        ),
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      ),
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget _buildCapacity() {
    return TextFormField(
      controller: capacityController,
      maxLength: 100,
      decoration: InputDecoration(
        labelText: 'Capacity',
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.green),
        ),
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      ),
      keyboardType: TextInputType.url,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget _buildStatus() {
    return TextFormField(
      controller: statusController,
      maxLength: 100,
      decoration: InputDecoration(
        labelText: 'Status',
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.green),
        ),
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      ),
      keyboardType: TextInputType.url,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Add new bus'),
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildID(),
                _buildModel(),
                _buildDriver(),
                _buildCapacity(),
                //_buildStatus(),
                const SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      final ID = IDController.text;
                      final model = modelController.text;
                      final driver = driverController.text;
                      final capacity = int.parse(capacityController.text);
                      //final status = statusController.text;

                      final time = Timestamp.now();
                      //String stat = "Pending";

                      createBus(
                          ID: ID,
                          model: model,
                          driver: driver,
                          capacity: capacity,
                          //status: status,
                          time: time);

                      IDController.clear();
                      modelController.clear();
                      driverController.clear();
                      capacityController.clear();
                      // statusController.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            )),
      ),
    );
  }
}

Future createBus(
    {required String ID,
    required String model,
    required String driver,
    required int capacity,
    //required String status,
    required Timestamp time}) async {
  final docBuses = FirebaseFirestore.instance.collection("buses").doc();

  final json = {
    'id': ID,
    'model': model,
    'driver': driver,
    'capacity': capacity,
    //'status': status,
    'timestamp': time,
  };

  await docBuses.set(json);
}
