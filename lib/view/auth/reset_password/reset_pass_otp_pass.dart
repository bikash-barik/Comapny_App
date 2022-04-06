import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../utils/common_helper.dart';
import '../../utils/constant_colors.dart';

class ResetPassOtpPage extends StatefulWidget {
  const ResetPassOtpPage({Key? key}) : super(key: key);

  @override
  _ResetPassOtpPageState createState() => _ResetPassOtpPageState();
}

class _ResetPassOtpPageState extends State<ResetPassOtpPage> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  String currentText = "";
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Reset password'),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80.0,
              width: 80.0,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/email-circle.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "Enter the 4 digit code",
              style: TextStyle(
                  color: cc.greyPrimary,
                  fontSize: 21,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 13,
            ),
            CommonHelper().paragraphCommon(
                'Enter the 4 digit code we sent to to your email in order to reset password',
                TextAlign.center),
            const SizedBox(
              height: 33,
            ),
            Form(
              child: PinCodeTextField(
                appContext: context,
                length: 4,
                keyboardType: TextInputType.number,
                obscureText: false,
                animationType: AnimationType.fade,
                showCursor: true,
                cursorColor: cc.greyFive,

                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 70,
                    activeFillColor: Colors.white,
                    borderWidth: 1.5,
                    selectedColor: cc.primaryColor,
                    activeColor: cc.primaryColor,
                    inactiveColor: cc.greyFive),
                animationDuration: const Duration(milliseconds: 200),
                // backgroundColor: Colors.white,
                // enableActiveFill: true,
                errorAnimationController: errorController,
                controller: textEditingController,
                onCompleted: (v) {},
                onChanged: (value) {
                  print(value);
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Didn\'t receive?  ',
                    style:
                        const TextStyle(color: Color(0xff646464), fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const SignUpPage()));
                            },
                          text: 'Send again',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: cc.primaryColor,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
