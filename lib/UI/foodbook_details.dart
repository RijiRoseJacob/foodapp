import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/main.dart';
import 'package:yumfood/resources.dart/images/food_colors.dart';
import 'package:yumfood/resources.dart/images/foodimages.dart';
import 'package:yumfood/resources.dart/strings.dart';
import 'package:yumfood/resources.dart/widgets.dart';

class FoodBookDetail extends StatefulWidget {
  static String tag = '/FoodBookDetail';

  @override
  FoodBookDetailState createState() => FoodBookDetailState();
}

class FoodBookDetailState extends State<FoodBookDetail> {
  var mPeople = 0;
  var mTime = 0;
  var mFood = 0;
  var mPeopleList, mTimeList, mFoodList;
  var now = new DateTime.now();
  var count = 1;
  var formatter = new DateFormat('dd  MMM');
  late String formatted;

  @override
  void initState() {
    super.initState();
    mPeopleList = ["1", "2", "3", "4", "5+"];
    mFoodList = ["Veg", "Non Veg"];
    mTimeList = ["07:00", "07:30", "08:00", "08:30", "09:00", "09:15", "09:30", "10:00", "10:30", "11:00"];
    formatted = formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    //changeStatusColor(food_app_background);
    var width = MediaQuery.of(context).size.width;

    final mPeopleInfo = Container(
      height: width * 0.1,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: mPeopleList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                mPeople = index;
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 16, top: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: mPeople == index
                      ? food_colorPrimary
                      : appStore.isDarkModeOn
                          ? cardDarkColor
                          : food_colorPrimary_light),
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Text(
                mPeopleList[index],
                style: primaryTextStyle(
                    color: mPeople == index
                        ? food_white
                        : appStore.isDarkModeOn
                            ? white
                            : food_textColorPrimary),
              ).center(),
            ),
          );
        },
      ),
    );

    final mTimeInfo = GridView.builder(
      scrollDirection: Axis.vertical,
      itemCount: mTimeList.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              mTime = index;
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: mTime == index
                    ? food_colorPrimary
                    : appStore.isDarkModeOn
                        ? cardDarkColor
                        : food_colorPrimary_light),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(
              mTimeList[index],
              style: primaryTextStyle(
                  color: mTime == index
                      ? food_white
                      : appStore.isDarkModeOn
                          ? white
                          : food_textColorPrimary),
            ).center(),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 2.0,
      ),
    );

    final mFoodInfo = Container(
      height: width * 0.1,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: mFoodList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                mFood = index;
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 16, top: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: mFood == index
                      ? food_colorPrimary
                      : appStore.isDarkModeOn
                          ? cardDarkColor
                          : food_colorPrimary_light),
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Text(
                mFoodList[index],
                style: primaryTextStyle(
                    color: mFood == index
                        ? food_white
                        : appStore.isDarkModeOn
                            ? white
                            : food_textColorPrimary),
              ).center(),
            ),
          );
        },
      ),
    );

    return Scaffold(
      appBar: appBar(context, food_lbl_reserve_table),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: SvgPicture.asset(food_dinner_table, height: width * 0.4, width: width * 0.4),
                      ),
                      SizedBox(height: 16),
                      Text(food_lbl_how_many_people, style: boldTextStyle()),
                      SizedBox(height: 4),
                      mPeopleInfo,
                      SizedBox(height: 16),
                      Text(food_lbl_reservation_date, style: boldTextStyle()),
                      SizedBox(height: 4),
                      Text(formatted, style: primaryTextStyle()),
                      SizedBox(height: 16),
                      Text(food_lbl_set_your_time, style: boldTextStyle()),
                      SizedBox(height: 4),
                      mTimeInfo,
                      SizedBox(height: 16),
                      Text(food_lbl_any_food_preference, style: boldTextStyle()),
                      SizedBox(height: 4),
                      mFoodInfo,
                      SizedBox(height: 24),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: food_colorPrimary,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: defaultBoxShadow(),
                        ),
                        child: TextButton(onPressed: ()=>storeBookingDetails(),
                          
                          child:Text(food_lbl_book_table, style: primaryTextStyle(color: white)).center(),)
                      ),
                      SizedBox(height: 16),
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
  Future<void> storeBookingDetails() async {
  // Build the booking details map.
  // We use the selected indices to get the actual values from your lists.
  final bookingDetails = {
    "people": mPeopleList[mPeople], // e.g., "1", "2", "3", etc.
    "reservation_date": formatted,  // formatted date string
    "time": mTimeList[mTime],       // selected time string
    "food_preference": mFoodList[mFood], // e.g., "Veg" or "Non Veg"
    "timestamp": FieldValue.serverTimestamp(),
  };

  try {
    await FirebaseFirestore.instance.collection("tableBookings").add(bookingDetails);
    // After storing, show a SnackBar with an OK button.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Table booked successfully"),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {
            // This can dismiss the snack bar, or you could navigate somewhere else.
          },
        ),
      ),
    );
  } catch (e) {
    print("Error storing booking details: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error booking table"),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
        ),
      ),
    );
  }
}

}// for spacing, etc.

