import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:video_player/video_player.dart';

typedef PageChanged = void Function(int index);

class VideoShow extends StatefulWidget {
  final String? url; //图片列表

  const VideoShow(this.url, {Key? key});
  @override
  _VideoShowState createState() => _VideoShowState();
}

class _VideoShowState extends State<VideoShow> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.network(
    //     "https://apd-de65eba5d4eb9dda16d0ca27506194e8.v.smtcdns.com/vlive.qqvideo.tc.qq.com/A-8JgFsxEwqTn-aGJH8t7x8EfyLeRnQZaCfamwvOm7bc/svp_1050/gzc_1000173_0b53o4aa6aaa7aai2w5xrnrru5yeb53qad2a.f112007.mp4?vkey=457CA68BC3FF109A5B2BD223A03F71823831AAF0F92F26C09369024C9052D7F9227660A8DE12546C2BBB2A1037B64DDF554D3078EC79D3688DE44C86B4D49B0042417DA6039E3C58203DB9C3DCFF75B5A796EBB5D1C8D202290302E3F52FB943A6C504AE14D34B457F5E1C0527F8836E9FCAAB2F704EA9F4&platform=11001&fmt=hd&level=0")
    //   ..initialize().then((_) {
    //     _controller.play();
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
    _controller = VideoPlayerController.network(widget.url!)
      ..initialize().then((_) {
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.pause();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const Text("", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.black,
            shadowColor: Colors.white,
            toolbarOpacity: 1,
            systemOverlayStyle: SystemUiOverlayStyle.light
                .copyWith(statusBarColor: Colors.black),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                AppUtil.back();
              },
            )),
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
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ));
  }
}
