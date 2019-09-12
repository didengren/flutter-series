/// 通用Webview骨架 - 为h5页面提供调用相机功能（其它系统能力后续添加）
/// Created by Sam Xu
/// Date: 2019-02-11

import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../../utils/common_utils.dart';
import './MixinZWebviewScaffoldState.dart';
import '../z_loading/ZLoading.dart';
import '../z_toast/ZToast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZWebviewScaffold extends StatefulWidget {
  final String url;
  final bool hasAppBar;
  final Widget title;
  final List<Widget> tabItems;
  final Color indicatorColor;
  final Widget bottomBar;
  final bool appCacheEnabled;

  ZWebviewScaffold(@required this.url, {
    Key key,
    this.hasAppBar = true,
    this.title,
    this.tabItems,
    this.indicatorColor,
    this.bottomBar,
    this.appCacheEnabled = true
  }) : super(key: key);

  @override
  _ZWebviewScaffoldState createState() {
    // TODO: implement createState
    return _ZWebviewScaffoldState(
      url,
    );
  }
}

class _ZWebviewScaffoldState extends State<ZWebviewScaffold> with SingleTickerProviderStateMixin, MixinZWebviewScaffoldState<ZWebviewScaffold> {
  static const WEB_VIEW_CLOSE_FLAG = '@close';

  final String _url;
  WebViewController _controller;
  String jsData;

  @protected
  _ZWebviewScaffoldState(
      this._url,
      ) : super();

  @override
  void initState() {
    super.initState();
    CookieManager().clearCookies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
        body: SafeArea(
            child: WebView(
              initialUrl: _url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
              },
              javascriptChannels: <JavascriptChannel>[
                JavascriptChannel(
                    name: 'GoBack',
                    onMessageReceived: (JavascriptMessage message) {
                      print('message___________${message.message}');
                      Navigator.pop(context);
                    }
                ),
                JavascriptChannel(
                    name: 'CameraUpload',
                    onMessageReceived: (JavascriptMessage message) {
                      try {
                        Map<String, dynamic> _map = convert.jsonDecode(message.message);
                        print('message.message________${message.message}');
                        cameraService(_map['intent'], sec: _map['sec'] == null ? null : int.parse(_map['sec'])).then((res) {
                          // TODO LIST
                          // uploadFn(res, _map['intent']);
                        });
                      } catch(err) {
                        print('err_____${err.toString()}');
                        Toast.toast(context, '$err');
                      }
                    }
                )
              ].toSet(),
//          navigationDelegate: (NavigationRequest request) {
//            print('____________________________________________________________________lalalal____________________');
//            if (request.url.startsWith('https://www.youtube.com/')) {
//              print('blocking navigation to $request}');
//              return NavigationDecision.prevent;
//            }
//            return NavigationDecision.navigate;
//          },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
                _controller.evaluateJavascript('routeStackLevel').then((res) {
                  jsData = res;
                });
              },
            )
        ),
      ),
      onWillPop: () {
        if(jsData == '1') Navigator.pop(context);
        else {
          print('___________________触发h5返回____________________');
          _controller.evaluateJavascript('winVue.\$router.go(-1)');
        }
        return Future.value(false);
      },
    );
  }
}
