import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../color.dart';

class Ok extends StatefulWidget {
  const Ok({super.key});

  @override
  State<Ok> createState() => _OkState();
}

final GlobalKey webViewKey = GlobalKey();
Uri myUrl = Uri.parse(
    "https://mature-whippet-bd9.notion.site/98e7bdb250ed4f538edce52447e4bf56");
late final InAppWebViewController webViewController;
double progress = 0;

class _OkState extends State<Ok> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: ColorList.primary,
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            elevation: 0,
            backgroundColor: ColorList.primary,
            centerTitle: true,
            title: Container(
              child: const Text('개인정보처리방침',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white)),
            )),
        body: SafeArea(
            child: WillPopScope(
                onWillPop: () async {
                  if (await webViewController.canGoBack()) {
                    webViewController.goBack();
                    return Future.value(false); // 현재 페이지를 유지
                  } else {
                    return Future.value(true); // 현재 페이지를 종료
                  }
                },
                child: Column(children: <Widget>[
                  progress < 1.0
                      ? LinearProgressIndicator(
                          value: progress, color: Colors.blue)
                      : Container(),
                  Expanded(
                      child: Stack(children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(url: myUrl),
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                            javaScriptCanOpenWindowsAutomatically: true,
                            javaScriptEnabled: true,
                            useOnDownloadStart: true,
                            useOnLoadResource: true,
                            useShouldOverrideUrlLoading: true,
                            mediaPlaybackRequiresUserGesture: true,
                            allowFileAccessFromFileURLs: true,
                            allowUniversalAccessFromFileURLs: true,
                            verticalScrollBarEnabled: true,
                            userAgent:
                                'Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36'),
                        android: AndroidInAppWebViewOptions(
                            useHybridComposition: true,
                            allowContentAccess: true,
                            builtInZoomControls: true,
                            thirdPartyCookiesEnabled: true,
                            allowFileAccess: true,
                            supportMultipleWindows: true),
                        ios: IOSInAppWebViewOptions(
                          allowsInlineMediaPlayback: true,
                          allowsBackForwardNavigationGestures: true,
                        ),
                      ),
                      onLoadStop: (InAppWebViewController controller, uri) {
                        setState(() {
                          myUrl = uri!;
                        });
                      },
                      onCreateWindow: (controller, createWindowRequest) async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 400,
                                child: InAppWebView(
                                  // Setting the windowId property is important here!
                                  windowId: createWindowRequest.windowId,
                                  initialOptions: InAppWebViewGroupOptions(
                                    android: AndroidInAppWebViewOptions(
                                      builtInZoomControls: true,
                                      thirdPartyCookiesEnabled: true,
                                    ),
                                    crossPlatform: InAppWebViewOptions(
                                      mediaPlaybackRequiresUserGesture: false,
                                      cacheEnabled: true,
                                      javaScriptEnabled: true,
                                      userAgent:
                                          "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36",
                                    ),
                                    ios: IOSInAppWebViewOptions(
                                      allowsInlineMediaPlayback: true,
                                      allowsBackForwardNavigationGestures: true,
                                    ),
                                  ),
                                  onCloseWindow: (controller) async {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        );
                        return true;
                      },
                    )
                  ]))
                ]))));
  }
}
