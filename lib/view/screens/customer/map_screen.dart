// ignore_for_file: unnecessary_new

import 'dart:async';
import 'dart:convert';
import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  double zoomVal = 5.0;

  /// Custom info window state
  Set<Marker> _markers = {};
  LatLng? _selectedLatLng;
  String _selectedName = "";
  bool _showInfo = false;
  Offset _infoWindowOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          _buildGoogleMap(context),

          /// INFO WINDOW
          if (_showInfo && _selectedLatLng != null)
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 75,
              top: 140,
              child: _buildInfoWindow(),
            ),

          _zoomminusfunction(),
          _zoomplusfunction(),
          _buildContainer(),
        ],
      ),
    );
  }

  // -------------------------
  // CUSTOM ALWAYS-VISIBLE INFO WINDOW
  // -------------------------
  Widget _buildInfoWindow() {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedName,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              "This is a Garage",
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  // --------------------------------------------
  // MARKER FUNCTION WITH ALWAYS-VISIBLE INFO WINDOW
  // --------------------------------------------
  setMarkers(double lat, double long, String name) async {
    _selectedLatLng = LatLng(lat, long);
    _selectedName = name;
    _showInfo = true;

    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId("garage"),
          position: _selectedLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          onTap: () async {
            _showInfo = true;
            _selectedLatLng = LatLng(lat, long);
            await _updateInfoWindowPosition();
          },
        ),
      };
    });

    await _updateInfoWindowPosition();
  }

  Future<void> _updateInfoWindowPosition() async {
    if (_selectedLatLng == null) return;

    final GoogleMapController controller = await _controller.future;

    ScreenCoordinate screenCoordinate =
    await controller.getScreenCoordinate(_selectedLatLng!);

    // Shift window up by 80px to keep it above the marker
    setState(() {
      _infoWindowOffset = Offset(
        screenCoordinate.x.toDouble() - 75,  // center horizontally
        screenCoordinate.y.toDouble() - 120, // move above marker
      );
    });
  }


  // --------------------------------------------
  // ZOOM OUT
  // --------------------------------------------
  Widget _zoomminusfunction() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(FontAwesomeIcons.searchMinus, color: Color(0xff6200ee)),
        onPressed: () {
          zoomVal--;
          _minus(zoomVal);
        },
      ),
    );
  }

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(FontAwesomeIcons.searchPlus, color: Color(0xff6200ee)),
        onPressed: () {
          zoomVal++;
          _plus(zoomVal);
        },
      ),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomTo(zoomVal));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomTo(zoomVal));
  }

  // -----------------------------------------------------
  // MAP BUILDER
  // -----------------------------------------------------
  Widget _buildGoogleMap(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      initialCameraPosition:
      CameraPosition(target: LatLng(18.520430, 73.856743), zoom: 12),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: _markers,
      onCameraMove: (cameraPos) {
        if (_showInfo) setState(() {}); // keep info window visible
      },

    );
  }

  // --------------------------------------------
  // LIST BELOW MAP
  // --------------------------------------------
  Widget _buildContainer() {
    return Consumer<GarageProvider>(
      builder: (context, model, child) => Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model.allGarageList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(8),
                child: _boxes(
                  model.allGarageList[index].imageUrl,
                  double.parse(model.allGarageList[index].latitude),
                  double.parse(model.allGarageList[index].longitude),
                  model.allGarageList[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _boxes(String img, double lat, double long, Garage g) {
    return GestureDetector(
      onTap: () {
        if (g.latitude == "" || g.longitude == "") {
          showSimpleNotification(
            Text("This Garage is not located on map",
                style: TextStyle(color: Colors.white)),
            background: Colors.black,
          );
        } else {
          _gotoLocation(lat, long, g.name);
        }
      },
      child: FittedBox(
        child: Material(
          color: Colors.white,
          elevation: 14,
          borderRadius: BorderRadius.circular(24),
          shadowColor: Color(0x802196F3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // IMAGE
              Container(
                width: 180,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: img == ""
                      ? Image.asset("assets/images/1.jpg", fit: BoxFit.fill)
                      : Image.network(img, fit: BoxFit.fill),
                ),
              ),

              // DETAILS
              Container(
                padding: EdgeInsets.all(8),
                child: myDetailsContainer1(g),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget myDetailsContainer1(Garage garage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // GARAGE NAME
        Text(
          garage.name,
          style: TextStyle(
            color: Color(0xff6200ee),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 5),

        // ⭐ RATING ROW
        Row(
          children: [
            Text(
              garage.rating.toString(),
              style: TextStyle(color: Colors.black54, fontSize: 18),
            ),
            SizedBox(width: 6),

            // Dynamic stars (corrected)
            ...List.generate(
              5,
                  (i) => Icon(
                i < garage.rating.floor()
                    ? FontAwesomeIcons.solidStar
                    : FontAwesomeIcons.star,
                color: Colors.amber,
                size: 15,
              ),
            ),

            SizedBox(width: 6),

            Text(
              garage.noOfRating.toString(),
              style: TextStyle(color: Colors.black54, fontSize: 18),
            ),
          ],
        ),

        SizedBox(height: 5),

        // WEBSITE
        Text(
          garage.websiteUrl,
          style: TextStyle(color: Colors.black54, fontSize: 18),
        ),

        SizedBox(height: 5),

        // CLOSING TIME
        Text(
          "Open: Closes at ${garage.closingTime}",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // --------------------------------------------
  // GO TO LOCATION
  // --------------------------------------------
  Future<void> _gotoLocation(double lat, double long, String garageName) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, long),
          zoom: 15,
          tilt: 50.0,
          bearing: 45.0,
        ),
      ),
    );

    setMarkers(lat, long, garageName);
  }

// -------------------------------------------------
}
