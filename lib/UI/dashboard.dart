import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/Auth/signIn_screen.dart';
import 'package:yumfood/UI/add_address.dart';
import 'package:yumfood/UI/description.dart';
import 'package:yumfood/UI/favorite.dart';
import 'package:yumfood/UI/foodbook_cart.dart';
import 'package:yumfood/UI/foodbook_details.dart';
import 'package:yumfood/UI/order.dart';
import 'package:yumfood/UI/view_restaurent.dart';
import 'package:yumfood/main.dart';
import 'package:yumfood/model.dart';
import 'package:yumfood/resources.dart/data_generator.dart';
import 'package:yumfood/resources.dart/images/food_colors.dart';
import 'package:yumfood/resources.dart/images/foodimages.dart';
import 'package:yumfood/resources.dart/strings.dart';
import 'package:yumfood/resources.dart/widgets.dart';
import 'FoodProfile.dart';

class FoodDashboard extends StatefulWidget {
  static String tag = '/FoodDashboard';

  @override
  FoodDashboardState createState() => FoodDashboardState();
}

class FoodDashboardState extends State<FoodDashboard> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late List<DashboardCollections> mCollectionList;
  late List<Restaurants> mBakeryList;
  late List<Restaurants> mDeliveryList;
  late List<Restaurants> mDineOutList;
  late List<DashboardCollections> mExperienceList;
  late List<Restaurants> mCafeList;

  @override
  void initState() {
    super.initState();
    mCollectionList = addCollectionData();
    mBakeryList = addBakeryData();
    mDeliveryList = addDeliveryRestaurantsData();
    mDineOutList = addDineOutRestaurantsData();
    mExperienceList = addCuisineData();
    mCafeList = addCafeData();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(appStore.isDarkModeOn ? black : white);
    Widget topGradient(var gradientColor1, var gradientColor2, var icon, var heading, var subHeading) {
      var width = MediaQuery.of(context).size.width;
      return GestureDetector(
        onTap: () {
          FoodViewRestaurants().launch(context);
        },
        child: Container(
          decoration: gradientBoxDecoration(showShadow: true, gradientColor1: gradientColor1, gradientColor2: gradientColor2),
          padding: EdgeInsets.all(10),
          child: (Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SvgPicture.asset(icon, color: food_white, width: width * 0.06, height: width * 0.06),
              Text(heading, style: primaryTextStyle(color: food_white)),
              Text(
                subHeading,
                style: primaryTextStyle(color: food_white, size: 12),
              ),
            ],
          )),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  Text(food_app_name, style: boldTextStyle(size: 18)),
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      FoodBookCart().launch(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: context.cardColor),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          mAddress(context),
                          SizedBox(height: 16),
                          search(context),
                          SizedBox(height: 16),
                          Row(
  children: [
    Expanded(
      child: GestureDetector(
        onTap: () {
          // Navigate to FoodOrder screen
          FoodOrder().launch(context);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [food_color_blue_gradient1, food_color_blue_gradient2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: defaultBoxShadow(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                food_cloche,
                color: food_white,
                width: MediaQuery.of(context).size.width * 0.06,
                height: MediaQuery.of(context).size.width * 0.06,
              ),
              Text(food_lbl_food_order,
                  style: primaryTextStyle(color: food_white)),
              Text("See your order history",
                  style: primaryTextStyle(color: food_white, size: 12)),
            ],
          ),
        ),
      ),
    ),
    SizedBox(width: 10),
    Expanded(
      child: GestureDetector(
        onTap: () {
          // Navigate to FoodBookDetail screen (or Book Table screen)
          FoodBookDetail().launch(context);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [food_color_orange_gradient1, food_color_orange_gradient2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: defaultBoxShadow(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                food_ic_table,
                color: food_white,
                width: MediaQuery.of(context).size.width * 0.06,
                height: MediaQuery.of(context).size.width * 0.06,
              ),
              Text(food_lbl_book_a_table,
                  style: primaryTextStyle(color: food_white)),
              Text(food_lbl_may_take_upto_3_mins,
                  style: primaryTextStyle(color: food_white, size: 12)),
            ],
          ),
        ),
      ),
    ),
  ],
)
,
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: context.cardColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          heading(food_lbl_get_inspired_by_collections),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: mCollectionList.length,
                              padding: EdgeInsets.only(right: 16),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Collection(mCollectionList[index], index);
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: context.cardColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          heading(food_lbl_cake_ice_cream_and_bakery),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: mBakeryList.length,
                              padding: EdgeInsets.only(bottom: 4, right: 16),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Item(mBakeryList[index], index);
                              },
                            ),
                          ),
                          mViewAll(context, food_lbl_view_all_restaurants, onTap: () {
                            FoodViewRestaurants().launch(context);
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: context.cardColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          heading(food_lbl_delivery_restaurants),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(bottom: 4, right: 16),
                              itemCount: mDeliveryList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Item(mDeliveryList[index], index);
                              },
                            ),
                          ),
                          mViewAll(context, food_lbl_view_all_restaurants, onTap: () {
                            FoodViewRestaurants().launch(context);
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: context.cardColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          heading(food_lbl_dine_out_restaurants),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: mDineOutList.length,
                              padding: EdgeInsets.only(bottom: 4, right: 16),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Item(mDineOutList[index], index);
                              },
                            ),
                          ),
                          mViewAll(context, food_lbl_view_all_restaurants, onTap: () {
                            FoodViewRestaurants().launch(context);
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: context.cardColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          heading(food_lbl_experience_your_favourite_cuisine),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(right: 16),
                              itemCount: mExperienceList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Collection(mExperienceList[index], index);
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: context.cardColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          heading(food_lbl_cafe),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(bottom: 4, right: 16),
                              itemCount: mCafeList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Item(mCafeList[index], index);
                              },
                            ),
                          ),
                          mViewAll(context, food_lbl_view_all_restaurants, onTap: () {
                            FoodViewRestaurants().launch(context);
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      drawer: FoodSideMenu(),
    );
  }
}

// ignore: must_be_immutable
class Item extends StatelessWidget {
  late Restaurants model;

  Item(Restaurants model, int pos) {
    this.model = model;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FoodDescription().launch(context);
      },
      child: Container(
        width: width * 0.4,
        margin: EdgeInsets.only(left: 16),
        decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                    imageUrl: model.image,
                    height: width * 0.3,
                    width: width * 0.4,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    onPressed: () {
                      addToFavorites(model);
                    },
                    icon: Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.favorite_border, color: food_white, size: 18),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(model.name, style: primaryTextStyle(), maxLines: 2),
                  4.height,
                  Row(
                    children: <Widget>[
                      mRating(model.rating.toString()),
                      Text(
                        model.review,
                        style: primaryTextStyle(color: food_textColorSecondary, size: 14),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
  void addToFavorites(Restaurants model) async {
    try {
      await FirebaseFirestore.instance.collection("favorites").add({
        "name": model.name,
        "image": model.image,

        "timestamp": FieldValue.serverTimestamp(),
      });
      // Show a confirmation
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text("${model.name} added to favorites")),
      );
    } catch (e) {
      print("Error adding to favorites: $e");
    }
  }



// ignore: must_be_immutable
class Collection extends StatelessWidget {
  late DashboardCollections model;

  Collection(DashboardCollections model, int pos) {
    this.model = model;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FoodViewRestaurants().launch(context);
      },
      child: Container(
        margin: EdgeInsets.only(left: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                imageUrl: model.image,
                width: width * 0.5,
                height: 250,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(model.name, style: primaryTextStyle(size: 20, fontFamily: 'Andina', color: white)),
                  SizedBox(height: 4),
                  Text(model.info, style: primaryTextStyle(size: 14, color: food_white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodSideMenu extends StatefulWidget {
  @override
  FoodSideMenuState createState() => FoodSideMenuState();
}

class FoodSideMenuState extends State<FoodSideMenu> {
  
  Widget mOption(var gradientColor1, var gradientColor2, var icon, var value, var tags) {
    return GestureDetector(
      onTap: () {
        finish(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => tags));
//         launchScreen(context, tags);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [gradientColor1, gradientColor2]),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(icon, size: 18, color: food_white),
              ),
            ),
            SizedBox(width: 16),
            Text(
              value,
              style: primaryTextStyle(),
            )
          ],
        ),
      ),
    );
  }

   String firstName = "";
  String lastName = "";
  String email = "";
@override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Function to fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User1')
          .doc('profile')
          .get();

      if (userDoc.exists) {
        print('User data: ${userDoc.data()}');
        setState(() {
          firstName = userDoc['First Name'] ?? "Unknown";
          lastName = userDoc['Last name'] ?? "";
          email = userDoc['Email'] ?? "No Email";
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }



  @override
  Widget build(BuildContext context)  {
    var width = MediaQuery.of(context).size.width;

    var mView = Container(width: MediaQuery.of(context).size.width, height: 0.5, color: food_view_color);
    
    return SafeArea(
      child: SizedBox(
        width: width * 0.85,
        height: MediaQuery.of(context).size.height,
        child: Drawer(
          elevation: 8,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  width: width,
                  decoration: gradientBoxDecoration(gradientColor1: food_colorPrimary, gradientColor2: food_colorPrimary, radius: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(backgroundImage: CachedNetworkImageProvider(food_ic_user1), radius: 40),
                      Text('${firstName} ${lastName}', style: primaryTextStyle(color: food_white)),
                      Text('${email}', style: primaryTextStyle(color: white))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 24, 16),
                  child: Column(
                    children: <Widget>[
                      mOption(food_color_blue_gradient1, food_color_blue_gradient2, Icons.favorite_border, food_lbl_favourite, FoodFavourite()),
                      mOption(food_color_orange_gradient1, food_color_orange_gradient2, Icons.add, food_lbl_add_address, FoodAddAddress()),
                      mOption(food_color_yellow_gradient1, food_color_yellow_gradient2, Icons.insert_drive_file, food_lbl_orders, FoodOrder()),
                      mOption(food_color_blue_gradient1, food_color_blue_gradient2, Icons.person_outline, food_lbl_profile, FoodProfile()),
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [food_color_orange_gradient1, food_color_orange_gradient2]),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Image.asset('assets/Images/ic_theme.png', height: 24, width: 24, color: food_white),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Text(
                                  'Dark Mode',
                                  style: primaryTextStyle(),
                                )
                              ],
                            ),
                            Switch(
                              value: appStore.isDarkModeOn,
                              activeColor: appColorPrimary,
                              onChanged: (s) {
                                appStore.toggleDarkMode(value: s);
                              },
                            )
                          ],
                        ),
                      ),
                      mOption(food_color_yellow_gradient1, food_color_yellow_gradient2, Icons.settings_power, food_lbl_logout, FoodSignIn()),
                    ],
                  ),
                ),
                mView,
                Container(
                  width: width,
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(food_lbl_quick_searches, style: primaryTextStyle()),
                      Text(food_lbl_cafe, style: primaryTextStyle(color: food_textColorSecondary)),
                      Text(food_hint_search_restaurants, style: primaryTextStyle(color: food_textColorSecondary)),
                      Text(food_lbl_bars, style: primaryTextStyle(color: food_textColorSecondary)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
