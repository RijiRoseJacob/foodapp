import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/resources.dart/images/food_colors.dart';
import 'package:yumfood/resources.dart/strings.dart';
import 'package:yumfood/resources.dart/widgets.dart';

class FoodOrder extends StatefulWidget {
  static String tag = '/FoodOrder';

  @override
  FoodOrderState createState() => FoodOrderState();
}

class FoodOrderState extends State<FoodOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, food_lbl_orders),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            16.height,
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("orders")
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final orders = snapshot.data!.docs;
                  if (orders.isEmpty) {
                    return Center(child: Text("No orders found."));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: orders.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final data = orders[index].data() as Map<String, dynamic>;
                      return Order(data, index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Updated Order widget that accepts a Map<String,dynamic> from Firestore.
class Order extends StatelessWidget {
  final Map<String, dynamic> data;
  final int pos;

  Order(this.data, this.pos);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // You can add an onTap callback here if needed.
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
                    backgroundImage: CachedNetworkImageProvider(data['image'] ?? ''),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(data['name'] ?? '', style: primaryTextStyle()),
                        Text(data['rate'] ?? '', style: primaryTextStyle()),
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
}
