import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_task_zigsaw/modals/modal.dart';
import 'package:restaurant_task_zigsaw/utilities/constants.dart';
import 'package:flutter_cache/flutter_cache.dart' as cache;

class DataController extends GetxController {
  var controller = TextEditingController();
  var hotel = Rxn<Hotel>();
  var searchHotel = <Item>[].obs;
  var isSearching = false.obs;
  fetchData() async {
    var params = {
      "access_token": "04fc7877ce7e5f771328b2a1434cb040ad1b2c0f",
      "api_key": "f14qd3se9a6juzbmoit85c0nrvhykgwp",
      "api_secret": "0ecb9930ec89b68dbc923d3ecedc43f37901cf61",
      "restID": "k13cv5ho",
      "last_updated_on": "",
      "data_type": "json"
    };
    var headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Cookie": "CAKEPHP=ikabifbaphe2m3eobl92here51"
    };

    var json = await cache.remember(
      'data',
      () async => await http
          .post(
            Uri.parse(APIURL),
            body: jsonEncode(params),
            headers: headers,
          )
          .then((value) => value.body),
    );
    hotel.value = Hotel.fromJson(json);
  }

  search(String searchQuery) {
    searchQuery = searchQuery.toLowerCase();
    searchHotel.clear();
    searchHotel.addAll(hotel.value!.items.where((element) =>
        element.itemname.toLowerCase().contains(searchQuery) ||
        element.itemdescription.toLowerCase().contains(searchQuery)));
  }

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }
}
