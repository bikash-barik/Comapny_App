import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../service/app_string_service.dart';
import '../utils/constant_colors.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    AppStringService asProvider =
        AppStringService(); // Replace with your instance of AppStringService

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 30), // Adding top margin of 20
        child: WebView(
          initialUrl:
              'https://glowtechmor.com', // Replace with your desired URL
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
