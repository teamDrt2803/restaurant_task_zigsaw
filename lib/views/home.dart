import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_task_zigsaw/controllers/datacontroler.dart';
import 'package:restaurant_task_zigsaw/modals/modal.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataController _dataController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        centerTitle: true,
        title: _buildAppbarTitle(),
        backgroundColor: Colors.transparent,
        actions: [
          Obx(
            () => Visibility(
              visible: !_dataController.isSearching.value,
              child: IconButton(
                icon: Icon(Icons.search),
                color: Colors.black,
                onPressed: () {
                  _dataController.isSearching.value =
                      !_dataController.isSearching.value;
                },
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Obx(
          () => _dataController.hotel.value == null
              ? Center(child: CircularProgressIndicator())
              : _buildItemList(),
        ),
      ),
    );
  }

  ListView _buildItemList() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: _dataController.isSearching.value
          ? _dataController.searchHotel.length
          : _dataController.hotel.value!.items.length,
      itemBuilder: (context, index) {
        var item = _dataController.isSearching.value
            ? _dataController.searchHotel[index]
            : _dataController.hotel.value!.items[index];
        return _buildListItem(item);
      },
    );
  }

  Container _buildListItem(Item item) {
    return Container(
      height: 130,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 16,
            offset: Offset(5, 8),
          )
        ],
      ),
      child: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              item.item_image_url.isNotEmpty
                  ? _buildProductImage(item)
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.fastfood_outlined,
                        size: 80,
                      ),
                    ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: _buildItemDetails(item),
              ),
            ],
          ),
          _buildAddButton()
        ],
      ),
    );
  }

  Positioned _buildAddButton() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: TextButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.green,
          ),
        ),
        onPressed: () {},
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Column _buildItemDetails(Item item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.itemname,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black54,
            fontSize: 18,
          ),
        ),
        Text(
          item.itemdescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        Text(
          "₹" + item.price,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Container _buildProductImage(Item item) {
    return Container(
      // height: 56,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(item.item_image_url),
        ),
      ),
    );
  }

  Obx _buildAppbarTitle() {
    return Obx(
      () => _dataController.isSearching.value
          ? CupertinoSearchTextField(
              onChanged: (searchQuery) {
                _dataController.search(searchQuery);
              },
              onSuffixTap: () {
                _dataController.isSearching.value = false;
                _dataController.searchHotel.clear();
              },
              suffixMode: OverlayVisibilityMode.always,
            )
          : Text(
              'Restaurant App',
              style: TextStyle(color: Colors.black),
            ),
    );
  }
}
