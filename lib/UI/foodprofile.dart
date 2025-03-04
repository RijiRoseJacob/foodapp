import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/UI/add_address.dart';
import 'package:yumfood/resources.dart/images/food_colors.dart';
import 'package:yumfood/resources.dart/images/foodimages.dart';
import 'package:yumfood/resources.dart/strings.dart';
import 'package:yumfood/resources.dart/widgets.dart';

TextEditingController mailController =TextEditingController();
TextEditingController nameController =TextEditingController();
TextEditingController name2Controller =TextEditingController();

class FoodProfile extends StatefulWidget {
  static String tag = '/FoodProfile';

  @override
  FoodProfileState createState() => FoodProfileState();
}

class FoodProfileState extends State<FoodProfile> {
  @override
  Widget build(BuildContext context) {
    String? _selectedGender = 'Female';
    return Scaffold(
      appBar: appBar(context, food_lbl_profile),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    16.height,
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        CircleAvatar(backgroundImage: CachedNetworkImageProvider(food_ic_user1), radius: 50),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: context.cardColor),
                          width: 30,
                          height: 30,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.edit, size: 16),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[Expanded(child: foodEditTextStyle(food_hint_first_name,controller: nameController)), SizedBox(width: 16), Expanded(child: foodEditTextStyle(food_hint_last_name,controller: name2Controller))],
                          ),
                          SizedBox(height: 16),
                          Container(
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
                              value: _selectedGender,
                              items: <String>['Female', 'Male'].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: primaryTextStyle(size: 12)),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedGender = newValue;
                                });
                              },
                            )),
                          ),
                          SizedBox(height: 16),
                          foodEditTextStyle(food_hint_mobile_no,controller: mobilenoController),
                          SizedBox(height: 16),
                          foodEditTextStyle(food_hint_email,controller: mailController),
                          SizedBox(height: 16),
                          TextButton(
                            onPressed: () async{
                              Map<String,dynamic>profile={
                              'First Name': nameController.text,
                              'Last name': name2Controller.text,
                              'Gender':_selectedGender,
                              'Mobile No':mobilenoController.text,
                              'Email':mailController.text,
                              };
                              await FirebaseFirestore.instance.collection('User1').doc('profile').set(profile).then((value){
                            return Text('Profile upated');});
                            Navigator.pop(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: food_colorPrimary, borderRadius: BorderRadius.circular(50), boxShadow: defaultBoxShadow()),
                              child: Text(
                                food_lbl_save_profile.toUpperCase(),
                                style: primaryTextStyle(color: white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
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
