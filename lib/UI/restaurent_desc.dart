import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/UI/description.dart';
import 'package:yumfood/UI/foodbook_details.dart';
import 'package:yumfood/UI/review.dart';
import 'package:yumfood/UI/view_restaurent.dart';
import 'package:yumfood/model.dart';
import 'package:yumfood/resources.dart/data_generator.dart';
import 'package:yumfood/resources.dart/images/food_colors.dart';
import 'package:yumfood/resources.dart/images/foodimages.dart';
import 'package:yumfood/resources.dart/strings.dart';
import 'package:yumfood/resources.dart/widgets.dart';

import '../../../main.dart';
import 'FoodGallery.dart';

TextEditingController restDescController = TextEditingController();

class FoodRestaurantsDescription extends StatefulWidget {
  static String tag = '/FoodRestaurantsDescription';

  @override
  FoodRestaurantsDescriptionState createState() =>
      FoodRestaurantsDescriptionState();
}

class FoodRestaurantsDescriptionState
    extends State<FoodRestaurantsDescription> {
  List<DataFilter> list = getAllData();
  late List<ReviewModel> mReviewList;
  late List<FoodDish> mList1; // Available items (grid view)
  List<FoodDish> mList2 = []; // Carted items; initially empty
  var mPeopleList, mCuisine;

  @override
  void initState() {
    super.initState();
    mReviewList = addReviewData();
    mList1 = addFoodDishData(); // available items
    mList2 = []; // initialize cart as empty
    mPeopleList = ["1", "2", "3", "4", "5"];
    mCuisine = [
      "South Indian",
      "American",
      "BBQ",
      "Bakery",
      "Biryani",
      "Burger",
      "Cafe",
      "Charcoal Chicken",
      "Chiness",
      "Fast Food",
      "Juice",
      "Gujarati",
      "Salad",
    ];

    changeStatusColor(Colors.transparent);
  }

  @override
  void dispose() {
    super.dispose();
    changeStatusColor(appStore.isDarkModeOn ? Colors.black : Colors.white);
  }

  // Callback to add an item to the cart (mList2)
  void addToCart(FoodDish dish) {
    setState(() {
      mList2.add(dish);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${dish.name} added to cart')));
  }

  // Custom heading widget used for section titles
  Widget mHeading(var value) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(
        value.toString().toUpperCase(),
        style: primaryTextStyle(),
      ),
    );
  }

  Widget mOption(var icon, var value) {
    return Container(
      child: Column(
        children: <Widget>[
          Icon(icon, color: food_colorPrimary, size: 20),
          Text(value, style: primaryTextStyle(size: 16)),
        ],
      ),
    );
  }

  Widget iconWithTitle(var icon, var value) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(icon,
                    color: food_textColorSecondary, size: 18)),
          ),
          TextSpan(
              text: value,
              style: primaryTextStyle(
                  size: 16,
                  color: appStore.isDarkModeOn
                      ? white
                      : food_textColorPrimary)),
        ],
      ),
    );
  }

  Widget mGallery(var icon, var value) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(icon,
                    color: appStore.isDarkModeOn
                        ? white
                        : food_textColorPrimary,
                    size: 18)),
          ),
          TextSpan(
              text: value,
              style: primaryTextStyle(
                  size: 16,
                  color: appStore.isDarkModeOn
                      ? white
                      : food_textColorPrimary)),
        ],
      ),
    );
  }

  Widget reviewOption(var heading, var rating) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(heading, style: primaryTextStyle(color: food_textColorSecondary)),
          Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width * 0.45,
              color: food_view_color),
          Text(rating, style: primaryTextStyle(color: food_textColorSecondary)),
        ],
      ),
    );
  }

  // Bottom sheet for review (unchanged)
  Widget? reviewBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return IntrinsicHeight(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)),
                  color: appStore.isDarkModeOn ? Colors.black : Colors.white,
                ),
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(food_lbl_rate_your_Experience,
                          style: primaryTextStyle()),
                      Wrap(
                        children: list
                            .asMap()
                            .map((i, e) => MapEntry(
                                  i,
                                  Tooltip(
                                    textStyle: TextStyle(fontSize: 16),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: food_colorPrimary,
                                        boxShadow: defaultBoxShadow()),
                                    padding: EdgeInsets.all(8),
                                    message: e.name!,
                                    child: InkWell(
                                      onTap: () {
                                        e.isCheck = !e.isCheck;
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: e.isCheck
                                                ? food_colorPrimary
                                                : food_view_color),
                                        margin: EdgeInsets.all(4),
                                        padding: EdgeInsets.all(8),
                                        child: Text(e.name!,
                                            style: secondaryTextStyle(
                                                color: e.isCheck ? white : black),
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                  ),
                                ))
                            .values
                            .toList(),
                      ),
                      SizedBox(height: 16),
                      Text(food_lbl_what_did_you_like,
                          style: primaryTextStyle()),
                      GridView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: mPeopleList.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  // example: update selected index
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: food_view_color,
                                ),
                                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text(mPeopleList[index],
                                    style: primaryTextStyle(
                                        color: food_textColorPrimary)).center(),
                              ),
                            );
                          },
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 2.0)),
                      SizedBox(height: 16),
                      Text(food_lbl_anything_else_you_want_to_add,
                          style: primaryTextStyle()),
                      foodEditTextStyle(food_hint_description,
                          controller: restDescController),
                      SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: food_colorPrimary,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: defaultBoxShadow()),
                        child: Text(food_lbl_submit,
                                style: primaryTextStyle(color: white))
                            .center(),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double expandHeight = MediaQuery.of(context).size.height * 0.33;
    var width = MediaQuery.of(context).size.width;
    var mTime = 0;

    return Scaffold(
      backgroundColor: food_app_background,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: expandHeight,
              floating: true,
              iconTheme: IconThemeData(
                  color: appStore.isDarkModeOn ? white : black),
              forceElevated: innerBoxIsScrolled,
              pinned: true,
              titleSpacing: 0,
              backgroundColor: context.cardColor,
              actionsIconTheme: IconThemeData(opacity: 0.0),
              title: Container(
                height: 60,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(),
                      Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.favorite_border,
                                  color: appStore.isDarkModeOn
                                      ? white
                                      : food_textColorPrimary),
                              onPressed: () {}),
                          IconButton(
                              icon: Icon(Icons.search,
                                  color: appStore.isDarkModeOn
                                      ? white
                                      : food_textColorPrimary),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FoodViewRestaurants()));
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  height: expandHeight,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      CachedNetworkImage(
                        placeholder:
                            placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                        imageUrl: food_ic_popular4,
                        width: width,
                        fit: BoxFit.cover,
                      ),
                      GestureDetector(
                        onTap: () {
                          FoodGallery().launch(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 16, bottom: 16),
                          height: width * 0.11,
                          width: width * 0.3,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: context.cardColor),
                          child: mGallery(Icons.image, food_lbl_photo),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            color: appStore.isDarkModeOn ? scaffoldDarkColor : white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Restaurant details
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      boxShadow: defaultBoxShadow(), color: context.cardColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(food_lbl_italian,
                          style: primaryTextStyle(color: food_color_red)),
                      Text(food_lbl_gravity_spacebar,
                          style: primaryTextStyle(size: 20)),
                      Row(
                        children: <Widget>[
                          Text(food_lbl_gurugram_sector_19,
                              style:
                                  primaryTextStyle(color: food_textColorSecondary)),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: food_textColorSecondary),
                            width: 4,
                            margin: EdgeInsets.only(right: 16, left: 4),
                            height: 4,
                          ),
                          Text(food_lbl_3_4_km_away,
                              style:
                                  primaryTextStyle(color: food_textColorSecondary)),
                        ],
                      ),
                      SizedBox(height: 12),
                      totalRatting(food_lbl__96_rating),
                      Divider(height: 0.5, color: food_view_color),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          mOption(Icons.call, food_lbl_call),
                          mOption(Icons.star_border, food_lbl_reviews),
                          mOption(Icons.add_box, food_lbl_add_photo),
                          mOption(Icons.directions, food_lbl_direction),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                FoodDescription().launch(context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                    color: food_colorPrimary,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(food_lbl_order_online,
                                        style: primaryTextStyle(color: white))
                                    .center(),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                FoodBookDetail().launch(context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: food_textColorPrimary),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(food_lbl_book_table,
                                        style: primaryTextStyle())
                                    .center(),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // Available items grid with "Add to Cart" button
                Container(
                  margin: EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                      boxShadow: defaultBoxShadow(), color: context.cardColor),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      mHeading(food_lbl_what_people_love_here),
                      SizedBox(height: 16),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.72,
                                  mainAxisSpacing: 16),
                          itemCount: mList1.length,
                          padding: EdgeInsets.only(bottom: 16),
                          itemBuilder: (context, index) {
                            return ItemGrid(
                              model: mList1[index],
                              onAddToCart: addToCart,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                // Carted items list (mList2)
                Container(
                  margin: EdgeInsets.only(top: 16, bottom: 16),
                  decoration: BoxDecoration(
                      boxShadow: defaultBoxShadow(), color: context.cardColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      mHeading("Cart Items"),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: mList2.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ItemList(mList2[index], index);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Revised ItemList widget (for carted items)
class ItemList extends StatelessWidget {
  final FoodDish model;
  final int pos;

  ItemList(this.model, this.pos);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(right: 16, left: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: CachedNetworkImage(
              placeholder:
                  placeholderWidgetFn() as Widget Function(BuildContext, String)?,
              imageUrl: model.image,
              width: width * 0.2,
              height: width * 0.2,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                          child: Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Image.asset(food_c_type,
                                  color: food_colorAccent,
                                  width: 16,
                                  height: 16))),
                      TextSpan(
                          text: model.name,
                          style: primaryTextStyle(
                              size: 16,
                              color: appStore.isDarkModeOn
                                  ? white
                                  : food_textColorPrimary)),
                    ],
                  ),
                ),
                Text(model.price, style: primaryTextStyle()),
              ],
            ),
          ),
          Text("Added",
              style: primaryTextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}

// Revised ItemGrid widget with "Add to Cart" button.
class ItemGrid extends StatelessWidget {
  final FoodDish model;
  final Function(FoodDish) onAddToCart;

  ItemGrid({required this.model, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      decoration: boxDecorationDefault(
        color: appStore.isDarkModeOn ? blackColor : food_white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            child: CachedNetworkImage(
              placeholder:
                  placeholderWidgetFn() as Widget Function(BuildContext, String)?,
              imageUrl: model.image,
              width: width,
              height: width * 0.3,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(model.name, style: primaryTextStyle(), maxLines: 1),
                Text(model.type,
                    style: primaryTextStyle(
                        color: food_textColorSecondary, size: 14)),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(model.price, style: primaryTextStyle()),
                    TextButton(
                      onPressed: () {
                        onAddToCart(model);
                      },
                      child: Text("Add to Cart",
                          style: primaryTextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

dialogContent(BuildContext context) {
  return Container(
      decoration: BoxDecoration(
        color: appStore.isDarkModeOn ? Colors.black : Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          )
        ],
      ),
      padding: EdgeInsets.all(24),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Snacks", style: primaryTextStyle()),
                Text("10/-", style: primaryTextStyle()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Pizza & Pasta", style: primaryTextStyle()),
                Text("40/-", style: primaryTextStyle()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Burger", style: primaryTextStyle()),
                Text("20/-", style: primaryTextStyle()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Fast Food", style: primaryTextStyle()),
                Text("12/-", style: primaryTextStyle()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Italian", style: primaryTextStyle()),
                Text("60/-", style: primaryTextStyle()),
              ],
            )
          ],
        ),
      ));
}
