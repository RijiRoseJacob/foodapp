import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:yumfood/UI/delivery_info.dart';
import 'package:yumfood/main.dart';
import 'package:yumfood/resources.dart/images/food_colors.dart';
import 'package:yumfood/resources.dart/images/foodimages.dart';
import 'package:yumfood/resources.dart/strings.dart';
import 'package:yumfood/resources.dart/widgets.dart';


class FoodPayment extends StatefulWidget {
  static String tag = '/FoodPayment';
  late final double totalAmount;
  FoodPayment({required this.totalAmount});

  @override
  FoodPaymentState createState() => FoodPaymentState();
}

class FoodPaymentState extends State<FoodPayment> {
 late Razorpay _razorpay;
 String email='';
 String Mobileno='';

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    fetchUserData();
  }
Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User1')
          .doc('profile')
          .get();

      if (userDoc.exists) {
        setState(() {
          email = userDoc['Email'] ?? "";
          Mobileno = userDoc['Mobile No'] ?? "";
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
  void openCheckout() {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY',
      'amount': (widget.totalAmount*100).toInt(), 
      'name': 'YumFood',
      'description': 'Order Payment',
      'prefill': {
        'contact': Mobileno,
        'email': email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Successful: ${response.paymentId}")));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Failed: ${response.message}")));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("External Wallet Used: ${response.walletName}")));
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
  
  

  
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget mPaymentOption(var icon, var heading, var value, var valueColor) {
      return Container(
        decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
        padding: EdgeInsets.all(4),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8),
            SvgPicture.asset(icon, width: width * 0.1, height: width * 0.1),
            SizedBox(height: 8),
            Text(heading, style: primaryTextStyle()),
            Text(value, style: primaryTextStyle(color: appStore.isDarkModeOn ? white : valueColor)),
          ],
        ),
      );
    }

    Widget mNetBankingOption(var icon, var value) {
      return Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.asset(food_ic_fab_back, width: width * 0.17, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
              Container(
                
                child: ElevatedButton(onPressed: (){
                  openCheckout();
                },
                  child: CachedNetworkImage(
                    placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                    imageUrl: icon,
                    width: width * 0.08,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 4),
          Text(value, style: primaryTextStyle())
        ],
      );
    }

    return Scaffold(
      // backgroundColor: food_app_background,
      bottomNavigationBar: bottomBillDetail(context, food_color_blue_gradient1, food_color_blue_gradient2, food_delivery_info, onTap: () {
        FoodDeliveryInfo().launch(context);
      }),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: width,
              alignment: Alignment.topLeft,
              color: appStore.isDarkModeOn ? scaffoldDarkColor : white,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  finish(context);
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: context.cardColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(food_lbl_payment, style: boldTextStyle(size: 18)),
                          SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1, 
                                child: mPaymentOption(food_google_wallet, food_lbl_google_wallet, '${widget.totalAmount}', food_color_red)),
                              SizedBox(width: 16),
                              Expanded(flex: 1, 
                              child: mPaymentOption(food_whatsapp, food_lbl_whatsapp_payment, food_lbl_connect, food_textColorPrimary)),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: context.cardColor),
                      margin: EdgeInsets.only(top: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(food_lbl_credit_cards.toUpperCase(), style: primaryTextStyle()),
                          SizedBox(height: 16),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: CachedNetworkImage(
                                        placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?, imageUrl: food_ic_hdfc, height: width * 0.05, width: width * 0.05),
                                  ),
                                ),
                                TextSpan(text: food_lbl__42xx_4523_xxxx_55xx, style: primaryTextStyle(size: 16, color: appStore.isDarkModeOn ? white : food_textColorPrimary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: context.cardColor),
                      margin: EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(food_lbl_netbanking.toUpperCase(), style: primaryTextStyle()),
                              mViewAll(context, food_lbl_view_all_banks, onTap: () {
                                //
                              }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              mNetBankingOption(food_ic_hdfc, food_lbl_hdfc),
                              mNetBankingOption(food_ic_rbs, food_lbl_rbs),
                              mNetBankingOption(food_ic_citi, food_lbl_citi),
                              mNetBankingOption(food_ic_america, food_lbl_america),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
