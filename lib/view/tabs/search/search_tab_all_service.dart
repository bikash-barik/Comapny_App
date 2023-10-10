import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/view/search/components/search_bar.dart' as sb1;
import 'package:qixer/view/search/components/search_bar_all_service.dart' as sb;
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';

class SearchTabAllService extends StatefulWidget {
  const SearchTabAllService({Key? key}) : super(key: key);

  @override
  _SearchTabAllServiceState createState() => _SearchTabAllServiceState();
}

class _SearchTabAllServiceState extends State<SearchTabAllService> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: physicsCommon,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenPadding),
                clipBehavior: Clip.none,
                child: Consumer<AppStringService>(
                  builder: (context, asProvider, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        CommonHelper().titleCommon(
                            asProvider.getString('Search services')),
                        sizedBox20(),
                        const sb.SearchBarAllService(),
                      ]),
                ),
              ),
            ),
          )),
    );
  }
}
