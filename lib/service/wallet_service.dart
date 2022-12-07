import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/model/wallet_history_model.dart';
import 'package:qixer/service/booking_services/place_order_service.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/service/payment_gateway_list_service.dart';
import 'package:qixer/view/home/landing_page.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:qixer/view/wallet/wallet_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletService with ChangeNotifier {
  var walletHistory;
  var walletBalance = '\$0.0';

  var walletHistoryId;

  bool isloading = false;
  bool hasWalletHistory = true;

  setLoadingStatus(bool status) {
    isloading = status;
    notifyListeners();
  }

  var amountToAdd;

  setAmount(v) {
    amountToAdd = v;
    notifyListeners();
  }

  // Fetch subscription history
  fetchWalletHistory(BuildContext context) async {
    var connection = await checkConnection();
    if (!connection) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    setLoadingStatus(true);

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    var response = await http.get(Uri.parse('$baseApi/user/wallet/history'),
        headers: header);

    final decodedData = jsonDecode(response.body);

    print('wallet history response ${response.body}');

    if (response.statusCode == 200 && decodedData['history'].isNotEmpty) {
      final data = WalletHistoryModel.fromJson(jsonDecode(response.body));
      walletHistory = data.history;
      notifyListeners();
    } else {
      print('Error fetching wallet history' + response.body);

      hasWalletHistory = false;
      notifyListeners();

      Future.delayed(const Duration(seconds: 1), () {
        hasWalletHistory = true;
      });
    }
  }

  // Fetch wallet balance
  Future<bool> fetchWalletBalance(BuildContext context) async {
    var connection = await checkConnection();
    if (!connection) return false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    setLoadingStatus(true);

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    var response = await http.get(Uri.parse('$baseApi/user/wallet/balance'),
        headers: header);

    print('wallet balance response ${response.body}');

    final decodedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      walletBalance = decodedData['balance'];
      notifyListeners();

      return true;
    } else {
      print('Error fetching wallet balance' + response.body);

      return false;
    }
  }

  //============>
  //=========>

  Future<bool> createDepositeRequest(BuildContext context,
      {imagePath,
      bool isManualOrCod = false,
      bool paytmPaymentSelected = false}) async {
    //get user id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var connection = await checkConnection();
    if (!connection) return false;
    //if connection is ok

    Provider.of<PlaceOrderService>(context, listen: false).setLoadingTrue();

    var selectedPayment =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .selectedMethodName ??
            'cash_on_delivery';

    FormData formData;
    var dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = "Bearer $token";

    if (imagePath != null) {
      formData = FormData.fromMap({
        'amount': amountToAdd,
        'payment_gateway': selectedPayment,
        'manual_payment_image': await MultipartFile.fromFile(imagePath,
            filename: 'bankTransfer.jpg'),
      });
    } else {
      formData = FormData.fromMap({
        'amount': amountToAdd,
        'payment_gateway': selectedPayment,
      });
    }

    var response = await dio.post(
      '$baseApi/user/wallet/deposit',
      data: formData,
    );

    Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();

    if (response.statusCode == 200) {
      walletHistoryId = response.data['deposit_info']['wallet_history_id'];

      if (isManualOrCod == true) {
        print('manual or code ran');
        doNext(context, 'Pending');
      }

      notifyListeners();

      return true;
    } else {
      print('error depositing to wallet ${response.data}');

      OthersHelper().showToast('Something went wrong', Colors.black);
      return false;
    }
  }

  ///////////==========>
  doNext(BuildContext context, String paymentStatus) async {
    //no need to make payment status complete
    inSuccess(context);
  }

  Future<bool> makeDepositeToWalletSuccess(BuildContext context) async {
    //make payment success

    var connection = await checkConnection();
    if (!connection) return false;
    //internet connection is on
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    print('wallet history id $walletHistoryId');
    var data = jsonEncode({'wallet_history_id': walletHistoryId});

    var response = await http.post(
        Uri.parse('$baseApi/user/wallet/deposit/payment-status'),
        headers: header,
        body: data);

    Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      inSuccess(context);
    } else {
      OthersHelper().showToast('Something went wrong', Colors.black);
    }

    return true;
  }

  // =========>
  inSuccess(BuildContext context) async {
    setAmount(null);
    OthersHelper().showToast('Wallet deposite success', Colors.black);

    await fetchWalletBalance(context);
    fetchWalletHistory(context);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LandingPage()),
        (Route<dynamic> route) => false);

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const WalletPage(),
      ),
    );
  }

  // =================>
  //===============>
  // deposite from current balance
  depositeFromCurrentBalance(BuildContext context, {required amount}) async {
    var connection = await checkConnection();
    if (!connection) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    setLoadingStatus(true);

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    var data = jsonEncode({'amount': amount});

    var response = await http.post(
        Uri.parse('$baseApi/seller/wallet/diposit-from-balance'),
        headers: header,
        body: data);

    final decodedData = jsonDecode(response.body);

    print(response.body);

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      print('Error deposite from current balance' + response.body);
    }
  }

  //=====================>
  //================>

  Future<bool> validate(BuildContext context, isFromDepositeToWallet) async {
    if (isFromDepositeToWallet && amountToAdd == null) {
      OthersHelper().showToast('You must enter an amount', Colors.black);
      return false;
    }
    if (isFromDepositeToWallet && double.tryParse(amountToAdd) == null) {
      // user entered non integer value
      OthersHelper().showToast('Please enter a valid amount', Colors.black);
      return false;
    }
    return true;
  }
}
