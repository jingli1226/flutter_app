import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:photo_view/photo_view_gallery.dart';

typedef PageChanged = void Function(int index);

class PictureOverview extends StatefulWidget {
  final String? image; //图片列表

  const PictureOverview({this.image = ""});
  @override
  _PictureOverviewState createState() => _PictureOverviewState();
}

class _PictureOverviewState extends State<PictureOverview> {
  List images = [];
  @override
  void initState() {
    super.initState();
    images = widget.image!.split(";");
    // TODO: implement initState
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        /*状态栏 背景透明*/
        systemNavigationBarColor: Colors.white //底部navigationBar背景颜色
        );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.black,
          shadowColor: Colors.white,
          toolbarOpacity: 1,
          systemOverlayStyle:
              SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.black),
          // leading: IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back_ios,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {},
          // )
        ),
        body: GestureDetector(
          onTap: () {
            SystemUiOverlayStyle systemUiOverlayStyle =
                const SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    /*状态栏 背景透明*/
                    systemNavigationBarColor: Colors.white //底部navigationBar背景颜色
                    );
            SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
            AppUtil.back();
          },
          child: Container(
              child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(images[index] ?? ""),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.black),
                  pageController: PageController(initialPage: 0),
                  onPageChanged: (index) => setState(() {}))),
        ));
  }
}
