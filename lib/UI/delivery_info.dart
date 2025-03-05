import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/resources.dart/images/food_colors.dart';
import 'package:yumfood/resources.dart/images/foodimages.dart';
import 'package:yumfood/resources.dart/rating_bar.dart';
import 'package:yumfood/resources.dart/strings.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class FoodDeliveryInfo extends StatefulWidget {
  static String tag = '/FoodDeliveryInfo';

  @override
  FoodDeliveryInfoState createState() => FoodDeliveryInfoState();
}

class FoodDeliveryInfoState extends State<FoodDeliveryInfo> {
  String distance = "";
  String duration = "";
  Future<void> fetchdeliveryData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('orders').doc('timestamp').get();

      if (userDoc.exists) {
        setState(() {
          distance = userDoc['Distance'] ?? "";
          duration = userDoc['Duration'] ?? "";
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
@override
  void initState() {
    fetchdeliveryData();
    super.initState();

  }

  int deliveryRating =0;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: food_view_color,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            MapSample(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 400,
                decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                margin: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Container(
                      transform: Matrix4.translationValues(0.0, -24.0, 0.0),
                      child: Stack(
                        children: <Widget>[
                          Image.asset(food_ic_fab_back, width: width * 0.15, height: width * 0.15, color: appStore.isDarkModeOn ? cardDarkColor : white),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              food_ic_delivery,
                              width: width * 0.08,
                              height: width * 0.08,
                              alignment: Alignment.center,
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(food_lbl_est_food_delivery_time.toUpperCase(), style: primaryTextStyle()),
                    SizedBox(height: 10),
                    Text(duration, style: primaryTextStyle(size: 18)),
                    Text(food_lbl_duration, style: primaryTextStyle(color: food_textColorSecondary)),
                    SizedBox(height: 10),
                    Text('$duration Km away', style: primaryTextStyle(size: 18)),
                    Text(food_lbl_distance, style: primaryTextStyle(color: food_textColorSecondary)),
                    SizedBox(height: 10),
                    Text(food_lbl__4_5_km_hr, style: primaryTextStyle(size: 18)),
                    Text(food_lbl_avg_speed, style: primaryTextStyle(color: food_textColorSecondary)),
                    Container(
                      height: 0.5,
                      color: food_view_color,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 10, bottom: 4),
                    ),
                    Text(food_lbl_rate_this_delivery, style: primaryTextStyle(color: food_colorPrimary)),
                    SizedBox(height: 8),
                    RatingBar(
                      initialRating: 0,
                      minRating: 1,
                      itemSize: 40,
                      direction: Axis.horizontal,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: food_color_yellow,
                        size: 30,
                      ),
                      onRatingUpdate: (rating) {
  setState(() async {
    deliveryRating = rating as int;
    await FirebaseFirestore.instance.collection('orders').add({
      'Rating': rating,
    });
  });
                         print("New rating: $rating");
                      }      
                    ),

                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, 
                    icon: Icon(Icons.arrow_back_ios,color: Colors.black,))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  // Variables to hold route details
  String distance = "";
  String duration = "";

  // Replace with your actual API key
  final String apiKey = "AIzaSyANgSEOQpGAsDBJL25xm-YhQoaDieLE25c";

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );
  


  @override
  void initState() {
    super.initState();
  }
  Future<void> fetchRouteDetails() async {
    
    final origin =
        "${_kGooglePlex.target.latitude},${_kGooglePlex.target.longitude}";
    final destination =
        "${_kLake.target.latitude},${_kLake.target.longitude}";
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'] != null && data['routes'].length > 0) {
        final leg = data['routes'][0]['legs'][0];
        setState(() async {
          distance = leg['distance']['text'];
          duration = leg['duration']['text'];
          await FirebaseFirestore.instance.collection('orders').add({
      'Distance': distance,
      'Duration': duration,
    });
        });
      }
    } else {
      print("Error fetching route details: ${response.statusCode}");
    }
  }

  // Animate camera to _kLake and fetch route details.
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    await fetchRouteDetails();
    int durationInMinutes = int.tryParse(duration.split(" ").first) ?? 0;
  Navigator.pop(context, durationInMinutes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map widget.
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          // Overlay container displaying distance and estimated delivery time.
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Distance: $distance",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text("Estimated Time: $duration",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Restaurant'),
        icon: Icon(Icons.restaurant),
      ),
    );
  }
}