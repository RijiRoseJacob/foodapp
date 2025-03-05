import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/UI/add_address.dart';
import 'package:yumfood/UI/coupon.dart';
import 'package:yumfood/UI/dashboard.dart';
import 'package:yumfood/UI/delivery_info.dart';
import 'package:yumfood/UI/payment.dart';
import 'package:yumfood/UI/view_restaurent.dart';
import 'package:yumfood/main.dart';
import 'package:yumfood/model.dart';
import 'package:yumfood/resources.dart/data_generator.dart';
import 'package:yumfood/resources.dart/food_theme.dart/dotted_border.dart';
import 'package:yumfood/resources.dart/images/food_colors.dart';
import 'package:yumfood/resources.dart/widgets.dart';

class FoodBookCart extends StatefulWidget {
  @override
  FoodBookCartState createState() => FoodBookCartState();
}

class FoodBookCartState extends State<FoodBookCart> {
  // Initially the cart is empty; items will be added when selected from the dashboard.
  List<FoodDish> cartItems = [];
  double subtotal = 0.0;
  double couponDiscount = 70.0; // example discount amount
  double gst = 0.0;
  double totalAmount = 0.0;
  

  // User address fields
  String address1 = '';
  String address2 = '';

  @override
void initState() {
  super.initState();
  // Instead of orderData(), use the global cart
  cartItems = globalCartItems;
  calculateTotal();
  fetchUserData();
}

  // Add an item to the cart.
  void addItem(FoodDish item) {
    setState(() {
      cartItems.add(item);
      calculateTotal();
    });
  }

  // Remove an item from the cart.
  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
      calculateTotal();
    });
  }

  void calculateTotal() {
    subtotal = cartItems.fold(0.0, (sum, item) => sum + double.parse(item.price));
    gst = subtotal * 0.05; // For example, GST is 5% of the subtotal.
    totalAmount = subtotal - couponDiscount + gst;
  }

  // Function to fetch user's delivery address from Firestore.
  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User1')
          .doc('Delivery address')
          .get();

      if (userDoc.exists) {
        setState(() {
          address1 = userDoc['Full name'] ?? "Unknown";
          address2 = userDoc['Address'] ?? "";
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Function to store order data to Firestore in collection "User1" as document "Order details".
  Future<void> storeOrderData() async {
    final orderDetails = {
  "items": cartItems.map((item) => {
        "name": item.name,
        "image": item.image,
        "rate": item.price,
        "quantity": 1, // customize as needed
      }).toList(),
  "subtotal": subtotal,
  "couponDiscount": couponDiscount,
  "GST": gst,
  "totalAmount": totalAmount,
  "timestamp": FieldValue.serverTimestamp(),
};

await FirebaseFirestore.instance.collection("orders").add(orderDetails);

  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    int _duration = 0;

    
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 220,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Padding(
                  padding: EdgeInsets.all(14),
                  child: Row(
                    children: [
                     IconButton(
  onPressed: () async {
    final returnedDuration = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (context) => MapSample()),
    );
    if (returnedDuration != null) {
      setState(() {
        _duration = returnedDuration;
      });
    }
  },
  icon: Icon(Icons.location_on, size: 30),
),

                      SizedBox(width: 8),
                    
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$address1', style:TextStyle(color: Colors.black,fontSize: 20)),
                            Text("Delivery time :$_duration Min",
                                style: primaryTextStyle(size: 14, color: food_textColorSecondary)),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => FoodAddAddress()));
                              },
                              child: Text('Change', style: TextStyle(color: Colors.blueAccent)),
                            ),
                          ],
                        ),
                      
                    ],
                  ),
                ),
                // Common "Add More Items" button
                
                // Payment Button – When tapped, stores order data then navigates to payment screen.
                SingleChildScrollView(
                  child: bottomBillDetail(
                    context,
                    food_color_blue_gradient1,
                    food_color_blue_gradient2,
                    "Make Payment",
                    onTap: () async {
                      await storeOrderData();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FoodPayment(totalAmount: totalAmount)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              onPressed: () {
                finish(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Your Cart", style: boldTextStyle(size: 24)),
                      SizedBox(height: 16),
                      // If the cart is empty, display a message; otherwise, list the items.
                      cartItems.isEmpty
                          ? Center(child: Text("Your cart is empty. Please add items."))
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: cartItems.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CartItem(
                                  model: cartItems[index],
                                  onDelete: () => removeItem(index),
                                );
                              },
                            ),
                      Divider(color: food_view_color, height: 0.5),
                      SizedBox(height: 8),
                      Text("Bill Details", style: boldTextStyle()),
                      billDetailRow("Subtotal", "Rs$subtotal"),
                      billDetailRow("Coupon Discount", "-Rs$couponDiscount"),
                      billDetailRow("GST (5%)", "Rs$gst"),
                      billDetailRow("Total Amount", "Rs$totalAmount", isBold: true),
                      SizedBox(height: 10),
                      DottedBorder(
                        color: food_colorAccent,
                        strokeWidth: 1,
                        padding: EdgeInsets.all(16),
                        radius: Radius.circular(16),
                        child: Container(
                          width: width,
                          padding: EdgeInsets.all(4),
                          color: food_color_light_primary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text("You can save upto 30% on this bill", style: primaryTextStyle()).center(),
                              ),
                              GestureDetector(
                          onTap: ()async {
                          double? discountAmount = await Navigator.push<double>(context,
                          MaterialPageRoute(builder: (context) => FoodCoupon(totalAmount: totalAmount)),
                                     );
                               
                               if (discountAmount != null) {
                                      setState(() {
                                couponDiscount = discountAmount;
                                   calculateTotal();
                                          });
                                          } },
                                child: Text("check with Coupon", style: primaryTextStyle()).center(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDashboard()));
                    },
                    child: Text("Add More Items",style: TextStyle(color: Colors.black,fontSize: 20),),
                  ),
                ),
                SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget billDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: isBold ? boldTextStyle() : primaryTextStyle()),
        Text(value, style: isBold ? boldTextStyle() : primaryTextStyle()),
      ],
    );
  }
}

class CartItem extends StatelessWidget {
  final FoodDish model;
  final VoidCallback onDelete;

  CartItem({required this.model, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
                      Text("\$${model.price}", style: primaryTextStyle()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Delete button to remove the item from the list.
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
