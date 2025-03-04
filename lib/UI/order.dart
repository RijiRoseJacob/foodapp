import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/model.dart';
import 'package:yumfood/resources.dart/data_generator.dart';
import 'package:yumfood/resources.dart/strings.dart';
import 'package:yumfood/resources.dart/widgets.dart';



class FoodOrder extends StatefulWidget {
  static String tag = '/FoodOrder';

  @override
  FoodOrderState createState() => FoodOrderState();
}

class FoodOrderState extends State<FoodOrder> {
  late List<FoodDish> mList2;

  @override
  void initState() {
    super.initState();
    mList2 = orderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, food_lbl_orders),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            16.height,
            ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: mList2.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Order(mList2[index], index);

              
                
              },
            ),
           

            
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Order extends StatelessWidget {
  late FoodDish model;

  Order(FoodDish model, int pos) {
    this.model = model;
  }

  @override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () {
      updateOrder(model);  // Update Firebase when item is tapped
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundImage: CachedNetworkImageProvider(model.image),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(model.name, style: primaryTextStyle()),
                      Text(model.price, style: primaryTextStyle()),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
  

void updateOrder(FoodDish model) async {
  try {
    await FirebaseFirestore.instance.collection('User1').doc('Order').set({
      'Dish name': model.name,
      'Price': model.price,
      'Dish': model.image,
      'timestamp': FieldValue.serverTimestamp(),
    });
    print("Order Updated Successfully");
  } catch (e) {
    print("Error updating order: $e");
  }
}

  }