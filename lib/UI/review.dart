import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/model.dart';
import 'package:yumfood/resources.dart/data_generator.dart';
import 'package:yumfood/resources.dart/images/food_colors.dart';
import 'package:yumfood/resources.dart/strings.dart';
import 'package:yumfood/resources.dart/widgets.dart';
import 'package:yumfood/main.dart';

class FoodReview extends StatefulWidget {
  static String tag = '/FoodReview';

  @override
  FoodReviewState createState() => FoodReviewState();
}

class FoodReviewState extends State<FoodReview> {
  late List<ReviewModel> mReviewList;

  @override
  void initState() {
    super.initState();
    mReviewList = addReviewData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, food_lbl_reviews),
        body: Column(
          children: <Widget>[
            16.height,
            Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: mReviewList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Review(mReviewList[index], index);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// --- Implementation for the missing Review widget ---
class Review extends StatelessWidget {
  final ReviewModel model;
  final int pos;

  Review(this.model, this.pos);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // User avatar image
          Container(
            margin: EdgeInsets.only(top: 8),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(model.image),
            ),
          ),
          SizedBox(width: 10),
          // Review details: review text, rating and duration
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(model.review, style: primaryTextStyle()),
              SizedBox(height: 4),
              Row(
                children: <Widget>[
                  mRating(model.rate),
                  SizedBox(width: 8),
                  Text(model.duration, style: primaryTextStyle(color: food_textColorSecondary, size: 16)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
