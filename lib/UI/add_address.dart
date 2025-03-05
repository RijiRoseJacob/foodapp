import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/resources.dart/images/food_colors.dart';
import 'package:yumfood/resources.dart/strings.dart';
import 'package:yumfood/resources.dart/widgets.dart';

    TextEditingController fullnameController =TextEditingController();
        TextEditingController pincodeController =TextEditingController();
        TextEditingController cityController =TextEditingController();
        TextEditingController stateController =TextEditingController();
        TextEditingController addressController =TextEditingController();
        TextEditingController mobilenoController =TextEditingController();
    

class FoodAddAddress extends StatefulWidget {
  static String tag = '/FoodAddAddress';
  @override
  FoodAddAddressState createState() => FoodAddAddressState();
}

class FoodAddAddressState extends State<FoodAddAddress> {
  String? _selectedLocation = 'Home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, food_lbl_add_address),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      foodEditTextStyle(food_hint_full_name,controller:fullnameController),
                      SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Expanded(child: foodEditTextStyle(food_hint_pin_code,controller:pincodeController)),
                          SizedBox(width: 16),
                          Expanded(child: foodEditTextStyle(food_hint_city,controller:cityController)),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Expanded(child: foodEditTextStyle(food_hint_state,controller:stateController)),
                          SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: food_view_color,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(40))),
                              width: MediaQuery.of(context).size.width,
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                value: _selectedLocation,
                                items: <String>['Home', 'Work'].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: primaryTextStyle(size: 16, color: food_textColorSecondary)),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedLocation = newValue;
                                  });
                                },
                              )),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      foodEditTextStyle(food_hint_address,controller:addressController),
                      SizedBox(height: 16),
                      foodEditTextStyle(food_hint_mobile_no,controller:mobilenoController),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: ()async{
                          
                          Map<String,dynamic>Address={
                            'Full name' :fullnameController.text,
                            'Pincode':pincodeController.text,
                            'City':cityController.text,
                            'State':stateController.text,
                            'Location':_selectedLocation,
                            'Address':addressController.text,
                            'Mobile No':mobilenoController.text

                          };
                          await FirebaseFirestore.instance.collection('User1').doc('Delivery address').set(Address).then((value){
                            return Text('Address upated');
                            
                          });
                          Navigator.pop(context);
                               },
                             child:  Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(color: food_colorPrimary, borderRadius: BorderRadius.circular(50),),
                           child:Text(food_lbl_add_address, style: primaryTextStyle(color: food_white)).center(),)
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
