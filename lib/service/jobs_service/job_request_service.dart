import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/model/job_request_model.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class JobRequestService with ChangeNotifier {
  List jobReqList = [];
  bool isloading = false;

  late int totalPages;

  int currentPage = 1;

  setLoadingStatus(bool status) {
    isloading = status;
    notifyListeners();
  }

  setCurrentPage(newValue) {
    currentPage = newValue;
    notifyListeners();
  }

  setTotalPage(newPageNumber) {
    totalPages = newPageNumber;
    notifyListeners();
  }

  fetchJobRequestList(context, {bool isrefresh = false}) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      jobReqList = [];

      notifyListeners();

      Provider.of<JobRequestService>(context, listen: false)
          .setCurrentPage(currentPage);
    } else {}

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var connection = await checkConnection();
    if (connection) {
      setLoadingStatus(true);

      var response = await http.get(
          Uri.parse(
              "$baseApi/user/job/request/request-lists?page=$currentPage"),
          headers: header);

      setLoadingStatus(false);

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 201 &&
          decodedData.containsKey('all_job_request') &&
          decodedData['all_job_request']['data'].isNotEmpty) {
        var data = JobRequestModel.fromJson(decodedData);

        setTotalPage(data.allJobRequest.lastPage);

        if (isrefresh) {
          //if refreshed, then remove all service from list and insert new data
          //make the list empty first so that existing data doesn't stay
          setServiceList(data.allJobRequest.data, false);
        } else {
          print('add new data');

          //else add new data
          setServiceList(data.allJobRequest.data, true);
        }

        currentPage++;
        setCurrentPage(currentPage);
        return true;
      } else {
        print(response.body);
        return false;
      }
    }
  }

  setServiceList(dataList, bool addnewData) {
    if (addnewData == false) {
      //make the list empty first so that existing data doesn't stay
      jobReqList = [];
      notifyListeners();
    }

    print(dataList);

    for (int i = 0; i < dataList.length; i++) {
      jobReqList.add(dataList[i]);
    }

    notifyListeners();
  }

  //hire
  // =========>

}
