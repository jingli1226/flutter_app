import 'package:flutter/material.dart';
import 'package:yigou/tools/config.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppView extends StatefulWidget {
  const UpdateAppView();

  @override
  UpdatePagerState createState() => UpdatePagerState();
}

class UpdatePagerState extends State<UpdateAppView> {
  var _serviceVersionCode,
      _serviceVersionName,
      _serviceVersionPlatform,
      _serviceVersionApp,
      _appDownloadUrl;

  @override
  void initState() {
    super.initState();
    //第一次打开APP时执行"版本更新"的网络请求
    _getNewVersionAPP();
  }

  //执行版本更新的网络请求
  _getNewVersionAPP() async {
    // try {
    //   Map config = await ApiService.getConfig();
    //   Map android = config["android"];
    //   Map ios = config["ios"];

    //   setState(() {
    //     _serviceVersionCode = android["version"].toString(); //版本号
    //     _serviceVersionName = android["buildNumber"].toString(); //版本名称
    //     _appDownloadUrl = android["downloadUrl"].toString(); //下载的URL
    //     _checkVersionCode();
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }

  //检查版本更新的版本号
  _checkVersionCode() async {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String _currentVersionCode = packageInfo.version;
    // int serviceVersionCode = int.parse(_serviceVersionCode); //String -> int
    // int currentVersionCode = int.parse(_currentVersionCode); //String -> int
    if (_serviceVersionCode != AppConfig.version) {
      _showNewVersionAppDialog(); //弹出对话框
    }
  }

  //弹出"版本更新"对话框
  Future<void> _showNewVersionAppDialog() async {
    //iOS
    return showDialog<void>(
        context: context,
        useSafeArea: false,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.asset("images/huojian.jpg",
                  width: 200, height: 140, fit: BoxFit.contain),
              Text("发现新版本v" + _serviceVersionCode,
                  style: const TextStyle(
                      color: AppConfig.font1, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "1.页面全新优化，用户体验更好；",
                      style: TextStyle(
                          color: AppConfig.font2, height: 1.6, fontSize: 14),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "2.新增主界面部分功能；",
                      style: TextStyle(
                          color: AppConfig.font2, height: 1.6, fontSize: 14),
                      textAlign: TextAlign.left,
                    ),
                    Text("3.解决部分bug问题。",
                        style: TextStyle(
                            color: AppConfig.font2, height: 1.6, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      child: const Text("取消",
                          style: TextStyle(color: AppConfig.font1)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        var timeStart = DateTime.now().millisecondsSinceEpoch;
                      },
                    )),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        child: const Text("立即升级",
                            style: TextStyle(color: AppConfig.font1)),
                        onPressed: () {
                          //_serviceVersionApp="http://itunes.apple.com/cn/lookup?id=项目包名"
                          launchUrl(
                              Uri.parse(_appDownloadUrl)); //到APP store 官网下载
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              )
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
