import 'package:flutter/material.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/constant_colors.dart';

class AllSecServices extends StatelessWidget {
  const AllSecServices({
    Key? key,
    required this.cc,
    required AppStringService asProvider,
  }) : super(key: key);

  final ConstantColors cc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin:
            const EdgeInsets.only(top: 30), // Adjust the top margin as needed
        child: const WebView(
          initialUrl:
              'https://www.glowtechmor.com', // Replace with your desired URL
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
