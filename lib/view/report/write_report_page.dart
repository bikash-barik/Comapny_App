// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/leave_feedback_service.dart';
import 'package:qixer/service/profile_service.dart';
import 'package:qixer/view/booking/components/textarea_field.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';

class WriteReportPage extends StatefulWidget {
  const WriteReportPage({
    Key? key,
    required this.serviceId,
    required this.orderId,
    required this.sellerId,
  }) : super(key: key);

  final serviceId;
  final orderId;
  final sellerId;
  @override
  State<WriteReportPage> createState() => _WriteReportPageState();
}

class _WriteReportPageState extends State<WriteReportPage> {
  double rating = 1;
  TextEditingController reviewController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('Report', context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        physics: physicsCommon,
        child: Consumer<ProfileService>(
          builder: (context, profileProvider, child) => Container(
            padding: EdgeInsets.symmetric(horizontal: screenPadding),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 15,
              ),
              sizedBox20(),
              Text(
                'What went wrong?',
                style: TextStyle(
                    color: cc.greyFour,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 14,
              ),
              TextareaField(
                notesController: reviewController,
                hintText: 'Write the issue',
              ),
              sizedBox20(),
              Consumer<LeaveFeedbackService>(
                builder: (context, lfProvider, child) =>
                    CommonHelper().buttonOrange('Report to admin', () {
                  if (lfProvider.isloading == false) {}
                }, isloading: lfProvider.isloading == false ? false : true),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
