import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
//import 'dart:js';

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  @override
  Widget build(BuildContext context) {
    var marker = <Marker>[];
    marker = [
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(20.153625, 28.568127),
        builder: (ctx) => Icon(
          Icons.pin_drop,
          color: Colors.green,
        ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(-18.9757714, 32.650351),
        builder: (ctx) => Icon(
          Icons.pin_drop,
          color: Colors.green,
        ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(-19.468531, 29.81208),
        builder: (ctx) => Icon(
          Icons.pin_drop,
          color: Colors.green,
        ),
      )
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text('Map View'),
        ),
        body: Column(
          children: [
            Expanded(
                child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: Column(
                  children: [
                    Flexible(
                        child: FlutterMap(
                      options: MapOptions(
                          center: LatLng(-17.824858, 31.053028), zoom: 6),
                      children: [
                        TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c']),
                        MarkerLayer(
                          markers: marker,
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            )),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [Text('Hello there')],
              ),
            )
          ],
        ));
  }
}
