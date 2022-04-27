import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qixer/view/utils/constant_colors.dart';

import '../utils/common_helper.dart';

class BookingHelper {
  ConstantColors cc = ConstantColors();

  List paymentImages = [
    'assets/icons/payment/paypal.png',
    'assets/icons/payment/cashfree.png',
    'assets/icons/payment/flutterwave.png',
    'assets/icons/payment/instamojo.png',
    'assets/icons/payment/mercado.png',
    'assets/icons/payment/midtrans.png',
    'assets/icons/payment/mollie.png',
    'assets/icons/payment/payfast.png',
    'assets/icons/payment/paystack.png',
    'assets/icons/payment/paytm.png',
    'assets/icons/payment/razorpay.png',
    'assets/icons/payment/stripe.png',
  ];

  bottomSheetDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 8,
          blurRadius: 17,
          offset: const Offset(0, 0), // changes position of shadow
        ),
      ],
    );
  }

  rowLeftRight(String iconLink, String title, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //icon
        Row(children: [
          SvgPicture.asset(
            iconLink,
            height: 19,
          ),
          const SizedBox(
            width: 7,
          ),
          Text(
            title,
            style: TextStyle(
              color: cc.greyFour,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          )
        ]),

        Text(
          text,
          style: TextStyle(
            color: cc.greyFour,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  bdetailsContainer(String iconLink, String title, String text) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      BookingHelper().rowLeftRight(iconLink, title, ''),
      const SizedBox(
        height: 10,
      ),
      Text(
        text,
        style: TextStyle(
          color: cc.greyFour,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      )
    ]);
  }

  bRow(String icon, String title, String text, {bool lastBorder = true}) {
    return Column(
      children: [
        Row(
          children: [
            //icon
            SizedBox(
              width: 125,
              child: Row(children: [
                icon != 'null'
                    ? Row(
                        children: [
                          SvgPicture.asset(
                            icon,
                            height: 19,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                        ],
                      )
                    : Container(),
                Text(
                  title,
                  style: TextStyle(
                    color: cc.greyFour,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ]),
            ),

            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: cc.greyFour,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
        lastBorder == true
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 14),
                child: CommonHelper().dividerCommon(),
              )
            : Container()
      ],
    );
  }

  detailsPanelRow(String title, int quantity, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: cc.greyFour,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        quantity != 0
            ? Expanded(
                child: Text(
                'x1',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cc.greyFour,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ))
            : Container(),
        Expanded(
          child: Text(
            '\$ $price',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: cc.greyFour,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  colorCapsule(String title, String capsuleText, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: cc.greyFour,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 11),
          decoration: BoxDecoration(
              color: color.withOpacity(.1),
              borderRadius: BorderRadius.circular(4)),
          child: Text(
            capsuleText,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        )
      ],
    );
  }
}
