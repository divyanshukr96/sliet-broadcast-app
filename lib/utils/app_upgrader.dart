import 'dart:async';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:sliet_broadcast/utils/network_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpgrade extends StatefulWidget {
  AppUpgrade({Widget child}) : child = child;

  final Widget child;

  @override
  _AppUpgradeState createState() => _AppUpgradeState();
}

class _AppUpgradeState extends State<AppUpgrade> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      _upgradeDialog();
    });
  }

  _toInteger(String value) {
    return int.parse(value.replaceAll('.', ''));
  }

  _upgradeDialog() async {
    Dio dio = new Dio();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Response response = await dio.get(NetworkUtils.host + "/api/appversion");

    String packageName = packageInfo.packageName;
    String installedVersion = packageInfo.version;
    String appStoreVersion =
        Platform.isIOS ? response.data['ios'] : response.data['android'];

    if (_toInteger(appStoreVersion) <= _toInteger(installedVersion)) return;

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update App'),
          content: Wrap(
            children: <Widget>[
              Text("A new version of "),
              Text(
                "SLIET Broadcast",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                  "is available! Version $appStoreVersion is now available, you have $installedVersion."),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text('Please update for using the application.'),
              ),
            ],
          ),
          actions: <Widget>[
//            FlatButton(child: Text('Ignore'), onPressed: () {}),
//            FlatButton(
//                child: Text('Later'),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                }),
            FlatButton(
              child: Text('Update Now'),
              onPressed: () async {
                String url =
                    "https://play.google.com/store/apps/details?id=$packageName";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {}
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
