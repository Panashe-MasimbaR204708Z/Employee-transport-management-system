//import 'dart:js';

//import 'package:flutter/material.dart';

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? phoneNumber;

  UserModel(
      {this.uid,
      this.email,
      this.firstName,
      this.phoneNumber,
      this.secondName});

  // data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        secondName: map['secondName'],
        phoneNumber: map['phoneNumber']);
  }

  // sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'phoneNumber': phoneNumber,
    };
  }
}

class Bus {
  String? id;
  String? routeId; // route ID that this bus is assigned to
  String? driverName;
  int? capacity;

  Bus({this.id, this.routeId, this.driverName, this.capacity});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routeId': routeId,
      'driverName': driverName,
      'capacity': capacity,
    };
  }

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      routeId: json['routeId'],
      driverName: json['driverName'],
      capacity: json['capacity'],
    );
  }
}

/*class Route {
  String? id;
  String? name;
  String? startLocation;
  String? endLocation;
  TimeOfDay? startTime;
  List<String>? busIds; // List of bus IDs assigned to this route

  Route(
      {this.id,
      this.name,
      this.startLocation,
      this.endLocation,
      this.startTime,
      this.busIds});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'startTime': startTime?.format(context as BuildContext).toString(),
      'busIds': busIds,
    };
  }

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'],
      name: json['name'],
      startLocation: json['startLocation'],
      endLocation: json['endLocation'],
      startTime: TimeOfDay.fromDateTime(DateTime.parse(json['startTime'])),
      busIds: json['busIds'] != null ? List<String>.from(json['busIds']) : null,
    );
  }
}*/
