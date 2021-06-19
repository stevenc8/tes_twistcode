import 'package:flutter/material.dart';
import 'package:tes_twistcode/model/cart_model.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class cartPage extends StatefulWidget {
  Function() callback;
  cartPage({this.callback});
  @override
  _cartPageState createState() => _cartPageState(callback);
}

class _cartPageState extends State<cartPage> {
  List<cartItem> listcartItem = [];
  Function() callback;
  _cartPageState(this.callback);
  int PriceTotal = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    String tempCart = prefs.getString('datacart');
    if (tempCart == '') {
      setState(() {
        listcartItem = [];
        PriceTotal = 0;
      });
    } else {
      final bodyJson = json.decode(tempCart);
      List<cartItem> CountPriceCartItem = [];
      int tempPriceTotal = 0;
      final tempListCartItem =
          (bodyJson as List).map((i) => new cartItem.fromJson(i));
      CountPriceCartItem.addAll(tempListCartItem);
      for (int i = 0; i < CountPriceCartItem.length; i++) {
        tempPriceTotal = tempPriceTotal +
            (CountPriceCartItem[i].quantity * CountPriceCartItem[i].brandPrice);
      }
      listcartItem.clear();
      setState(() {
        listcartItem.addAll(tempListCartItem);
        PriceTotal = tempPriceTotal;
      });
    }
  }

  _updateQuantityCart(int index, int id, String operator) async {
    final prefs = await SharedPreferences.getInstance();
    print(index);
    String tempProduct;
    var tempDataCart = [];
    int tempQuantityDisplay = 0;
    if (operator == "+") {
      listcartItem[index].quantity = listcartItem[index].quantity + 1;
    } else {
      listcartItem[index].quantity = listcartItem[index].quantity - 1;
      if (listcartItem[index].quantity == 0) {
        listcartItem.removeAt(index);
      }
    }
    // String tempCart = prefs.getString('datacart');
    // final bodyJson = json.decode(tempCart);

    // final tempListCartItem =
    //     (bodyJson as List).map((i) => new cartItem.fromJson(i));

    //listcartItem.addAll(tempListCartItem);

    if (listcartItem.length == 0) {
      prefs.setInt('dataquantitydisplay', 0);
      prefs.setString('datacart', '');
    } else {
      for (int i = 0; i < listcartItem.length; i++) {
        tempProduct = '{"cartId": ${listcartItem[i].cartId}, '
            '"image": "${listcartItem[i].image}", '
            '"brandName": "${listcartItem[i].brandName}", '
            '"brandPrice": ${listcartItem[i].brandPrice}, '
            '"quantity": ${listcartItem[i].quantity}, '
            '"weight": ${listcartItem[i].weight}}';
        tempQuantityDisplay = tempQuantityDisplay + listcartItem[i].quantity;
        //  if (listcartItem[i].quantity != 0) {
        tempDataCart.add(tempProduct);
        //   }
      }
      prefs.setInt('dataquantitydisplay', tempQuantityDisplay);
      prefs.setString('datacart', '$tempDataCart');
    }

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              callback();
              Navigator.of(context).pop();
            }),
        title: Text("Cart"),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 50.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 12, top: 10, bottom: 10),
                    child: Text("Produk yang akan anda pesan",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: listcartItem.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.3, //75.0,
                                  height: MediaQuery.of(context).size.width *
                                      0.28, //75.0,
                                  child: CachedNetworkImage(
                                    imageUrl: listcartItem[index].image,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(7.0),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 12, top: 10),
                                      child: Text(listcartItem[index].brandName,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                          textAlign: TextAlign.center),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 12, top: 5),
                                              child: Text(
                                                  "Rp " +
                                                      listcartItem[index]
                                                          .brandPrice
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.orange),
                                                  textAlign: TextAlign.center),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, top: 17),
                                              child: Text("(Baru)",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      _updateQuantityCart(
                                                          index,
                                                          listcartItem[index]
                                                              .cartId,
                                                          "-");
                                                    },
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12,
                                                                right: 12),
                                                        decoration:
                                                            new BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                color: Colors
                                                                    .red[400]),
                                                        child: Text("-",
                                                            style: TextStyle(
                                                                fontSize: 24,
                                                                color: Colors
                                                                    .white),
                                                            textAlign: TextAlign
                                                                .center)),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    child: Text(
                                                        listcartItem[index]
                                                            .quantity
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _updateQuantityCart(
                                                          index,
                                                          listcartItem[index]
                                                              .cartId,
                                                          "+");
                                                    },
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10),
                                                        decoration:
                                                            new BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                color: Colors
                                                                    .cyan[400]),
                                                        child: Text("+",
                                                            style: TextStyle(
                                                                fontSize: 24,
                                                                color: Colors
                                                                    .white),
                                                            textAlign: TextAlign
                                                                .center)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, top: 15),
                                              child: Text(
                                                  (listcartItem[index].weight *
                                                              listcartItem[
                                                                      index]
                                                                  .quantity
                                                                  .toDouble())
                                                          .toStringAsFixed(1) +
                                                      " Kg",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  listcartItem.length == 1
                      ? SizedBox(
                          height: MediaQuery.of(context).size.width * 0.89,
                        )
                      : listcartItem.length == 2
                          ? SizedBox(
                              height: MediaQuery.of(context).size.width * 0.5,
                            )
                          : listcartItem.length == 3
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.15)
                              : Container(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12))),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 18, top: 5),
                                  child: Text("Total harga",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                      textAlign: TextAlign.center),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 12, top: 5),
                                  child: Text("$PriceTotal",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.orange),
                                      textAlign: TextAlign.center),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(right: 20),
                              padding: EdgeInsets.only(
                                  left: 32, right: 32, top: 10, bottom: 10),
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.orange[400]),
                              child: Text("Order",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                  textAlign: TextAlign.center)),
                        ],
                      ),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
