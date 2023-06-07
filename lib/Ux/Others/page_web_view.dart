import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/BaseClasses/view_model_common.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Widgets/app_bar_widget.dart';
import 'package:twopa_sales_manager/Utils/app_device.dart';
import 'package:twopa_sales_manager/Utils/app_log.dart';
import 'package:twopa_sales_manager/main.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PageWebView extends StatefulWidget {
  final String title;
  final String webUrl;

  PageWebView(this.title, this.webUrl);

  @override
  _PageWebViewState createState() => _PageWebViewState();
}

class _PageWebViewState extends BasePageState<PageWebView, ViewModelCommon> {
  late WebViewController _webViewController;
  bool _showProgress = true;
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    _completer.future.then((controller) async {
      _webViewController = controller;
      var headers = {
        "token": mPreference.value.userToken,
        "authtoken": mPreference.value.authToken,
        "deviceid": await AppDevice.getDeviceId()
      };
      _webViewController.loadUrl(widget.webUrl, headers: headers);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLog.e("URL", widget.webUrl);
    return WillPopScope(
      onWillPop: _onBackClick,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AppBarWidget(widget.title, _onBackClick),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        color: kWhiteColor,
                        child: WebView(
                            initialUrl: widget.webUrl,
                            gestureNavigationEnabled: true,
                            javascriptMode: JavascriptMode.unrestricted,
                            onWebViewCreated: (controller) {
                              // _webViewController = controller;
                              _completer.complete(controller);
                            },
                            onPageStarted: (url) async {
                              setState(
                                  () => _showProgress = widget.webUrl == url);
                            },
                            onPageFinished: (url) {
                              setState(() => _showProgress = false);
                            }),
                      ),
                      if (_showProgress)
                        Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(kMainColor),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackClick() async {
    bool canGoBack = await _webViewController.canGoBack();

    if (canGoBack) {
      if (widget.title == "Bank Card") {
        Navigator.pop(context);
      } else {
        _webViewController.goBack();
      }
      return false;
    } else {
      if (widget.title == "Bank Card") {
        Navigator.pop(context);
      } else {
        if (Navigator.canPop(context)) Navigator.pop(context);
      }
      return true;
    }
  }
}
