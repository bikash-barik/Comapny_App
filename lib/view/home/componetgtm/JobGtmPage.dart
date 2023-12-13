import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class JobGtmPage extends StatelessWidget {
  const JobGtmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 30),
        child: WebView(
          initialUrl: 'https://glowtechmor.com/career/',
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith(
                'https://play.google.com/store/apps/details?id=com.glowtechmorservice.glowtechmor')) {
              _launchExternal(request.url); // Open Play Store links externally
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }

  void _launchExternal(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
