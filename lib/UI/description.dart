import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/UI/foodbook_cart.dart';
import 'package:yumfood/main.dart';
import 'package:yumfood/model.dart';
import 'package:yumfood/resources.dart/data_generator.dart';
import 'package:yumfood/resources.dart/images/food_colors.dart';
import 'package:yumfood/resources.dart/images/foodimages.dart';
import 'package:yumfood/resources.dart/strings.dart';
import 'package:yumfood/resources.dart/widgets.dart';

class FoodDescription extends StatefulWidget {
  static String tag = '/FoodDescription';

  @override
  FoodDescriptionState createState() => FoodDescriptionState();
}

class FoodDescriptionState extends State<FoodDescription> {
  late List<FoodDish> availableItems; // Items available (grid view)
  List<FoodDish> cartItems = []; // Cart list starts empty

  @override
void initState() {
  super.initState();
  availableItems = addFoodDishData() ?? []; // Fallback to empty list if null.
}


  // Callback when an item is added to the cart
  void addToCart(FoodDish dish) {
  setState(() {
    globalCartItems.add(dish);
  });
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('${dish.name} added to cart')));
}

  @override
  Widget build(BuildContext context) {
    double expandHeight = MediaQuery.of(context).size.height * 0.33;
    var width = MediaQuery.of(context).size.width;

    Widget mHeading(var value) {
      return Container(
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            value.toString().toUpperCase(),
            style: primaryTextStyle(),
          ));
    }

    Widget mVegOption(var value, var iconColor) {
      return Row(
        children: <Widget>[
          Image.asset(food_c_type, color: iconColor, width: 18, height: 18),
          SizedBox(width: 8),
          Text(value, style: primaryTextStyle()),
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: expandHeight,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                pinned: true,
                titleSpacing: 0,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: innerBoxIsScrolled
                            ? appStore.isDarkModeOn ? white : blackColor
                            : white),
                    onPressed: () {
                      finish(context);
                    }),
                backgroundColor: innerBoxIsScrolled
                    ? appStore.isDarkModeOn ? blackColor : food_white
                    : blackColor,
                actionsIconTheme: IconThemeData(opacity: 0.0),
                title: Container(
                  height: 60,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // You can add any additional widgets here
                        IconButton(
                          icon: Icon(Icons.search,
                              color: innerBoxIsScrolled
                                  ? appStore.isDarkModeOn ? white : blackColor
                                  : white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    height: expandHeight,
                    child: CachedNetworkImage(
                      placeholder:
                          placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                      imageUrl: food_ic_popular3,
                      height: expandHeight,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Description Card
                    Container(
                      width: width,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          boxShadow: defaultBoxShadow(), color: context.cardColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(food_lbl_burger,
                              style: primaryTextStyle(size: 18)),
                          totalRatting(food_lbl_order_rating),
                          SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              Container(
                                decoration: gradientBoxDecoration(
                                    gradientColor1: food_color_blue_gradient1,
                                    gradientColor2: food_color_blue_gradient2),
                                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                margin: EdgeInsets.only(right: 10),
                                child: Text(food_lbl_offer,
                                    style: primaryTextStyle(size: 14, color: white)),
                              ),
                              Text(food_lbl_save_14_on_each_night,
                                  style: primaryTextStyle(
                                      color: food_textColorSecondary))
                            ],
                          ),
                          SizedBox(height: 8),
                          Divider(height: 0.5, color: food_view_color),
                          SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: mVegOption(
                                      food_lbl_veg_only, food_view_color),
                                  flex: 1),
                              Expanded(
                                  child: mVegOption(
                                      food_lbl_non_veg_only, food_color_red),
                                  flex: 2),
                            ],
                          )
                        ],
                      ),
                    ),
                    // Delivery Info Card
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            boxShadow: defaultBoxShadow(), color: context.cardColor),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(food_ic_comass,
                                color: food_colorPrimary,
                                width: width * 0.08,
                                height: width * 0.08),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(food_lbl_delivery_by_yumfood_with_online_tracking,
                                      style: boldTextStyle()),
                                  Text(food_lbl_est_food_delivery_time,
                                      style: primaryTextStyle()),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Section: Available Items (Grid)
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: defaultBoxShadow(), color: context.cardColor),
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
                              itemCount: availableItems.length,
                              padding: EdgeInsets.only(bottom: 16),
                              itemBuilder: (context, index) {
                                return ItemGrid(
                                  model: availableItems[index],
                                  onAddToCart: addToCart,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Section: Cart Items (List)
                    Container(
                      decoration: boxDecorationDefault(
                        boxShadow: defaultBoxShadow(),
                        color: appStore.isDarkModeOn ? blackColor : food_white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          mHeading("Items in Cart"),
                          SizedBox(height: 16),
                          cartItems.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text("No items added to cart yet.",
                                      style: primaryTextStyle()),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: cartItems.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ItemList(
                                      model: cartItems[index],
                                      // Optionally, you can add a delete option here
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              // Bottom buttons: View Menu & Order Now
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomDialog(),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          decoration: gradientBoxDecoration(
                              gradientColor1: food_color_blue_gradient1,
                              gradientColor2: food_color_blue_gradient2,
                              radius: 40),
                          child: Text(food_lbl_view_menu,
                              style: primaryTextStyle(color: white)),
                        ),
                      ),
                      bottomBillDetail(context, food_color_green_gradient1,
                          food_color_green_gradient2, food_lbl_order_now,
                          onTap: () {
                        FoodBookCart().launch(context);
                      }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Revised ItemList widget: for cart items display (if needed)
class ItemList extends StatelessWidget {
  final FoodDish model;
  // You can add a delete callback here if required.
  ItemList({required this.model});

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
          // For cart items, you might simply display a label like "Added"
          Text("Added", style: primaryTextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}

// Revised ItemGrid widget: displays available items with "Add to Cart" button.
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
            borderRadius:
                BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
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
                Text(model.type, style: primaryTextStyle(color: food_textColorSecondary, size: 14)),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(model.price, style: primaryTextStyle()),
                    // Instead of a quantity button, display an "Add to Cart" text button.
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
