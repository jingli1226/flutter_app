import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:yigou/pages/widgets/MyButton.dart';

import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/storage.dart';

class CommentView extends StatefulWidget {
  String goodsId;
  CommentView(this.goodsId, {Key? key}) : super(key: key);

  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  TextEditingController commentEditer = TextEditingController();
  int ratingValue = 0;
  @override
  void initState() {
    super.initState();
  }

  void submit() async {
    List res = await StorageUtil.getComments();
    res.add({
      "id": AppUtil.getUUID(),
      "rate": ratingValue,
      "goodsId": widget.goodsId,
      "content": commentEditer.text,
      "time": AppUtil.formateTime()
    });
    await StorageUtil.saveComments(res);
    EasyLoading.showSuccess("评论成功");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark
              .copyWith(statusBarColor: Colors.transparent),
          // title: Text(user != null ? user["nickname"] : "",style:TextStyle(color: Colors.white),),
          centerTitle: true,
          elevation: 0.0,
          toolbarHeight: 40,
          title: MyText(
            "订单评价",
            weight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            AnimatedRatingStars(
              initialRating: 5,
              minRating: 0.0,
              maxRating: 5.0,
              onChanged: (double rating) {
                ratingValue = rating.toInt();
                // Handle the rating change here
                print('Rating: $rating');
              },
              filledColor: Colors.amber,
              emptyColor: Colors.grey,
              filledIcon: Icons.star,
              halfFilledIcon: Icons.star_half,
              emptyIcon: Icons.star_border,
              displayRatingValue: true,
              interactiveTooltips: true,
              customFilledIcon: Icons.star,
              customHalfFilledIcon: Icons.star_half,
              customEmptyIcon: Icons.star_border,
              starSize: 20.0,
              animationDuration: Duration(milliseconds: 300),
              animationCurve: Curves.easeInOut,
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              height: 100,
              decoration: BoxDecoration(color: Color(0xffeeeeee)),
              child: TextField(
                controller: commentEditer,
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: "输入评论"),
              ),
            ),
            MyButton(
              "提交评价",
              onTap: () {
                submit();
              },
            )
          ],
        ));
  }
}
