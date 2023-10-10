import 'package:flutter/material.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:qixer/view/utils/responsive.dart';

import '../../service/splash_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      screenSizeAndPlatform(context);
    });
    // runAtstart(context);
    // SplashService().loginOrGoHome(context);
    //run when app starts
  }

  startInitialization(BuildContext context) async {
    await runAtstart(context);
    initializeLNProvider(context);
    SplashService().loginOrGoHome(context);
  }

  @override
  Widget build(BuildContext context) {
    startInitialization(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          alignment: Alignment.center,
          // color: ConstantColors().primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fitHeight)),
              ),
              const SizedBox(height: 24),
              OthersHelper().showLoading(ConstantColors().primaryColor),
              const SizedBox(height: 24),
              Text(
                appVersion,
                style: TextStyle(
                    fontSize: 14,
                    color: ConstantColors().greyFour,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ));
  }
}
