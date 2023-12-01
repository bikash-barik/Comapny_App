import 'package:flutter/material.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/constant_colors.dart';

class JobGtmPage extends StatelessWidget {
  const JobGtmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 30), // Adding top margin of 20
        child: WebView(
          initialUrl:
              'https://glowtechmor.com/career/', // Replace with your desired URL
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
