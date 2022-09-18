// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/booking_services/place_order_service.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZitopayPaymentPage extends StatefulWidget {
  const ZitopayPaymentPage({
    Key? key,
  }) : super(key: key);

  @override
  _ZitopayPaymentPageState createState() => _ZitopayPaymentPageState();
}

class _ZitopayPaymentPageState extends State<ZitopayPaymentPage> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  bool alreadySuccessful = false;

  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (await controller.canGoBack()) {
            controller.goBack();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.blue,
              title: const Text("Zitopay"),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: IconButton(
                      onPressed: () async {
                        controller.reload();
                      },
                      icon: const Icon(Icons.refresh)),
                )
              ]),
          body: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl:
                "https://zitopay.africa/sci/?currency=XAF&amount=1000&receiver=dvrobin4&success_url=https%3A%2F%2Fwww.google.com%2F&cancel_url=https%3A%2F%2Fpub.dev",
            onWebViewCreated: (controller) {
              this.controller = controller;
            },
            navigationDelegate: (NavigationRequest request) async {
              if (request.url.contains('https://www.google.com/')) {
                //if payment is success, then the page is refreshing twice.
                //which is causing the screen pop twice.
                //So, this alreadySuccess = true trick will prevent that
                if (alreadySuccessful != true) {
                  print('payment success');
                  await Provider.of<PlaceOrderService>(context, listen: false)
                      .makePaymentSuccess(context);
                }

                setState(() {
                  alreadySuccessful = true;
                });

                return NavigationDecision.prevent;
              }
              if (request.url.contains('https://pub.dev/')) {
                print('payment failed');
                OthersHelper()
                    .showSnackBar(context, 'Payment failed', Colors.red);
                Navigator.pop(context);

                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        ),
      ),
    );
  }
}
