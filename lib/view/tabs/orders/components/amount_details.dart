import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/order_details_service.dart';
import 'package:qixer/view/booking/booking_helper.dart';
import 'package:qixer/view/utils/common_helper.dart';

class AmountDetails extends StatelessWidget {
  const AmountDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStringService>(
      builder: (context, asProvider, child) => Consumer<OrderDetailsService>(
        builder: (context, provider, child) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(9)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonHelper()
                        .titleCommon(asProvider.getString('Amount Details')),
                    const SizedBox(
                      height: 25,
                    ),
                    //Service row

                    Container(
                      child: BookingHelper().bRow(
                          'null',
                          asProvider.getString('Package fee'),
                          provider.orderDetails.packageFee.toString()),
                    ),

                    Container(
                      child: BookingHelper().bRow(
                          'null',
                          asProvider.getString('Extra service'),
                          provider.orderDetails.extraService.toString()),
                    ),

                    Container(
                      child: BookingHelper().bRow(
                          'null',
                          asProvider.getString('Sub total'),
                          provider.orderDetails.subTotal.toString()),
                    ),

                    Container(
                      child: BookingHelper().bRow(
                          'null',
                          asProvider.getString('Tax'),
                          provider.orderDetails.tax.toString()),
                    ),

                    Container(
                      child: BookingHelper().bRow(
                          'null',
                          asProvider.getString('Total'),
                          provider.orderDetails.total.toString()),
                    ),

                    Container(
                      child: BookingHelper().bRow(
                          'null',
                          asProvider.getString('Payment status'),
                          provider.orderDetails.paymentStatus,
                          lastBorder: false),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
