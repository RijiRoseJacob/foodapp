import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/model.dart';
import 'package:yumfood/resources.dart/images/food_colors.dart';
import 'package:yumfood/resources.dart/strings.dart';
import 'package:yumfood/resources.dart/widgets.dart';

class FoodFavourite extends StatefulWidget {
  static String tag = '/FoodFavourite';

  @override
  FoodFavouriteState createState() => FoodFavouriteState();
}

class FoodFavouriteState extends State<FoodFavourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, food_lbl_favourite),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("favorites").orderBy("timestamp", descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            final data = snapshot.data!.docs;
            return GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final itemData = data[index].data() as Map<String, dynamic>;
                // Create a FoodDish object from the data if needed,
                // or use itemData directly in your widget.
                FoodDish favoriteItem = FoodDish.fromMap(itemData);
                return Favourite(favoriteItem, index);
              },
            );
          },
        ),
      ),
    );
  }
}


// ignore: must_be_immutable
class Favourite extends StatelessWidget {
  late FoodDish model;

  Favourite(FoodDish model, int pos) {
    this.model = model;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
            child: CachedNetworkImage(
              placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
              imageUrl: model.image,
              height: width * 0.3,
              width: width,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(model.name, style: primaryTextStyle(), maxLines: 1),
                Text(model.type, style: primaryTextStyle(color: food_textColorSecondary)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text(model.price)],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FoodDish {
  String name;
  String image;
  String type;
  String price;

  FoodDish({
    required this.name,
    required this.image,
    required this.type,
    required this.price,
  });

  // Factory constructor to create a FoodDish from a map
  factory FoodDish.fromMap(Map<String, dynamic> data) {
    return FoodDish(
      name: data['name'] ?? "",
      image: data['image'] ?? "",
      type: data['type'] ?? "",
      price: data['price'] ?? "",
    );
  }

  // Convert FoodDish to map (optional, for saving data)
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "image": image,
      "type": type,
      "price": price,
    };
  }
}
