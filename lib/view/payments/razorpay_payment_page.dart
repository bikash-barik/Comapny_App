// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/jobs_service/job_request_service.dart';
import 'package:qixer/service/order_details_service.dart';
import 'package:qixer/service/wallet_service.dart';
import 'package:qixer/view/booking/booking_helper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../service/booking_services/place_order_service.dart';
import '../../service/payment_gateway_list_service.dart';

class RazorpayPaymentPage extends StatefulWidget {
  const RazorpayPaymentPage(
      {Key? key,
      required this.amount,
      required this.name,
      required this.phone,
      required this.email,
      required this.isFromOrderExtraAccept,
      required this.isFromWalletDeposite,
      required this.isFromHireJob})
      : super(key: key);

  final amount;
  final name;
  final phone;
  final email;
  final isFromOrderExtraAccept;
  final isFromWalletDeposite;
  final isFromHireJob;

  @override
  _RazorpayPaymentPageState createState() => _RazorpayPaymentPageState();
}

class _RazorpayPaymentPageState extends State<RazorpayPaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    initializeRazorPay();
  }

  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    launchRazorPay(context);
  }

  void launchRazorPay(BuildContext context) {
    double amountToPay = double.parse(widget.amount) * 100;

    var options = {
      'key': Provider.of<PaymentGatewayListService>(context, listen: false)
              .publicKey ??
          '',
      'amount': "$amountToPay",
      'name': widget.name,
      'description': ' ',
      'prefill': {'contact': widget.phone, 'email': widget.email}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Sucessfull");

    if (widget.isFromOrderExtraAccept == true) {
      Provider.of<OrderDetailsService>(context, listen: false)
          .acceptOrderExtra(context);
    }
    if (widget.isFromWalletDeposite) {
      Provider.of<WalletService>(context, listen: false)
          .makeDepositeToWalletSuccess(context);
    } else if (widget.isFromHireJob) {
      Provider.of<JobRequestService>(context, listen: false)
          .goToJobSuccessPage(context);
    } else {
      Provider.of<PlaceOrderService>(context, listen: false)
          .makePaymentSuccess(context);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payemt Failed");
    Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();
    PlaceOrderService().makePaymentFailed(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // print("Payment Failed");
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Razorpay"),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 25, right: 25),
                child:
                    BookingHelper().detailsPanelRow('Total', 0, widget.amount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(Size size, String text, bool isNumerical,
      TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height / 50),
      child: SizedBox(
        height: size.height / 15,
        width: size.width / 1.1,
        child: TextField(
          controller: controller,
          keyboardType: isNumerical ? TextInputType.number : null,
          decoration: InputDecoration(
            hintText: text,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
