import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:qixer/service/profile_service.dart';
import 'package:qixer/service/push_notification_service.dart';
import 'package:qixer/service/searchbar_with_dropdown_service.dart';
import 'package:qixer/view/auth/login/login.dart';
import 'package:qixer/view/home/componetgtm/AboutGtmPage.dart';
import 'package:qixer/view/home/componetgtm/ContactUsGTMPage.dart';
import 'package:qixer/view/home/componetgtm/JobGtmPage.dart';
import 'package:qixer/view/home/home.dart';
import 'package:qixer/view/notification/push_notification_helper.dart';
import 'package:qixer/view/tabs/settings/menu_page.dart';
import 'package:qixer/view/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../utils/others_helper.dart';
import 'bottom_nav.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<LandingPage> {
  // String? token;

  @override
  void initState() {
    // setToken();
    initPusherBeams(context);
    setChatSellerId(null);
    super.initState();
  }

  // Future<void> setToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     token = prefs.getString('token');
  //   });
  // }

  DateTime? currentBackPressTime;

  Future<void> onTabTapped(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token');

    if (index == 3) {
      Provider.of<SearchBarWithDropdownService>(context, listen: false)
          .resetSearchParams();
      Provider.of<SearchBarWithDropdownService>(context, listen: false)
          .fetchService(context);
    }

    if ((index == 1 || index == 4) && token == null) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const LoginPage(
            navigation: 'book',
          ),
        ),
      ).then((value) {
        if (value == true) {
          setState(() {
            _currentIndex = index;
          });

          Provider.of<ProfileService>(context, listen: false)
              .getProfileDetails();
        }
      });
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  int _currentIndex = 0;

  //Bottom nav pages
  final List<Widget> _children = [
    const Homepage(),
    const JobGtmPage(),
    const AboutGtmPage(),
    const ContactUsGTMPage(),
    const MenuPage(),
  ];

  //Notification alert
  //=================>
  initPusherBeams(BuildContext context) async {
    var pusherInstance =
        await Provider.of<PushNotificationService>(context, listen: false)
            .pusherInstance;

    if (pusherInstance == null) return;

    if (!kIsWeb) {
      await PusherBeams.instance
          .onMessageReceivedInTheForeground(_onMessageReceivedInTheForeground);
    }
    await _checkForInitialMessage(context);
    //init pusher instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');
    try {
      await PusherBeams.instance.addDeviceInterest('debug-buyer$userId');
    } catch (e) {}
  }

  Future<void> _checkForInitialMessage(BuildContext context) async {
    final initialMessage = await PusherBeams.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotificationHelper().notificationAlert(
          context, 'Initial Message Is:', initialMessage.toString());
    }
  }

  void _onMessageReceivedInTheForeground(Map<Object?, Object?> data) {
    Map metaData = data["data"] is Map ? data["data"] as Map : {};
    if (metaData["type"] == "message" &&
        metaData["sender-id"] == chatSellerId) {
      return;
    }
    PushNotificationHelper().notificationAlert(
        context, data["title"].toString(), data["body"].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
          onWillPop: () {
            DateTime now = DateTime.now();
            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime!) >
                    const Duration(seconds: 2)) {
              currentBackPressTime = now;
              OthersHelper().showToast("Press again to exit", Colors.black);
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: _children[_currentIndex]),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
}
