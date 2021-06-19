import 'package:flutter/material.dart';
import 'package:tes_twistcode/model/cart_model.dart';
import 'package:tes_twistcode/model/item_model.dart';
import 'package:tes_twistcode/cart.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<produkItem> listproduct = [];
  int quantityDisplay = 0;
  bool loading = true;
  String menuProduct = '[{"brandId": 0, '
      '"image": "https://pesanmbledoz.com/wp-content/uploads/2021/04/kisspng-juice-key-lime-mexican-cuisine-carrot-breakfast-avocado-5ab492d13f93a4.1547917415217835052604.png", '
      '"brandName": "Jus alpukat", '
      '"brandPrice": 20000, '
      '"city": "surabaya", '
      '"account": "tes@gmail.com",'
      '"weight": 0.1},'
      '{"brandId": 1, '
      '"image": "https://freepikpsd.com/media/2019/10/jus-jeruk-png-Transparent-Images.png", '
      '"brandName": "Jus jeruk", '
      '"brandPrice": 15000, '
      '"city": "jakarta", '
      '"account": "tes@gmail.com",'
      '"weight": 0.2},'
      '{"brandId": 2, '
      '"image": "https://teguk.co.id/wp-content/uploads/2020/05/Grape-Yakult-with-Popping-380x220-1-380x220.png", '
      '"brandName": "Es Kopyor", '
      '"brandPrice": 10000, '
      '"city": "surabaya", '
      '"account": "tes@gmail.com",'
      '"weight": 0.1},'
      '{"brandId": 3, '
      '"image": "https://satubmr.com/wp-content/uploads/2018/05/IMG_20180525_170359.jpg", '
      '"brandName": "Es Kelapa Muda", '
      '"brandPrice": 12000, '
      '"city": "jakarta", '
      '"account": "tes@gmail.com",'
      '"weight": 0.2}]';

  @override
  void initState() {
    super.initState();
    fetchData();
    // TODO: implement initState
  }

  Future fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    final bodyJson = json.decode(menuProduct);
    print(prefs.getString('datacart'));
    final tempListProduct =
        (bodyJson as List).map((i) => new produkItem.fromJson(i));
    setState(() {
      listproduct.addAll(tempListProduct);
      loading = false;
    });
  }

  _addtocart(int id) async {
    final prefs = await SharedPreferences.getInstance();
    bool sameItem = false;
    int tempquantityDisplay = 0;
    var newDataCartAll = [];
    String tempProduct = "";
    String cartProduct = '{"cartId": $id, '
        '"image": "${listproduct[id].image}", '
        '"brandName": "${listproduct[id].brandName}", '
        '"brandPrice": ${listproduct[id].brandPrice}, '
        '"quantity": 1, '
        '"weight": ${listproduct[id].weight}}';
    String tempCart = prefs.getString('datacart');
    if (tempCart == '' || tempCart == null) {
      prefs.setString('datacart', '[$cartProduct]');
      prefs.setInt('dataquantitydisplay', tempquantityDisplay);
      setState(() {
        quantityDisplay = 1;
      });
    } else {
      List<cartItem> oldcartItem = [];
      cartItem newcartItem;
      final bodyJsonOldCart = json.decode(tempCart);
      final bodyJsonNewCart = json.decode(cartProduct);
      final tempOldcartItem =
          (bodyJsonOldCart as List).map((i) => new cartItem.fromJson(i));
      oldcartItem.addAll(tempOldcartItem);
      newcartItem = cartItem.fromJson(bodyJsonNewCart);
      print(oldcartItem.length.toString());
      for (int i = 0; i < oldcartItem.length; i++) {
        if (oldcartItem[i].cartId == newcartItem.cartId) {
          oldcartItem[i].quantity = oldcartItem[i].quantity + 1;
          tempProduct = '{"cartId": ${oldcartItem[i].cartId}, '
              '"image": "${oldcartItem[i].image}", '
              '"brandName": "${oldcartItem[i].brandName}", '
              '"brandPrice": ${oldcartItem[i].brandPrice}, '
              '"quantity": ${oldcartItem[i].quantity}, '
              '"weight": ${oldcartItem[i].weight}}';

          tempquantityDisplay = tempquantityDisplay + oldcartItem[i].quantity;
          newDataCartAll.add(tempProduct);
          sameItem = true;
        } else {
          tempProduct = '{"cartId": ${oldcartItem[i].cartId}, '
              '"image": "${oldcartItem[i].image}", '
              '"brandName": "${oldcartItem[i].brandName}", '
              '"brandPrice": ${oldcartItem[i].brandPrice}, '
              '"quantity": ${oldcartItem[i].quantity}, '
              '"weight": ${oldcartItem[i].weight}}';

          tempquantityDisplay = tempquantityDisplay + oldcartItem[i].quantity;
          newDataCartAll.add(tempProduct);
        }
      }
      if (!sameItem) {
        // newDataCartAll.addAll(tempCart);
        tempquantityDisplay = tempquantityDisplay + newcartItem.quantity;
        newDataCartAll.add(cartProduct);
      }
      prefs.setInt('dataquantitydisplay', tempquantityDisplay);
      setState(() {
        quantityDisplay = prefs.getInt('dataquantitydisplay');
      });
      prefs.setString('datacart', '$newDataCartAll');
    }
    print(prefs.getString('datacart'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => cartPage(callback: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  quantityDisplay =
                                      prefs.getInt('dataquantitydisplay') ?? 0;
                                });
                              })),
                    );
                  },
                ),
              ),
              quantityDisplay == 0
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(left: 20, top: 5),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red[500],
                          ),
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text("$quantityDisplay"))
            ],
          )
        ],
      ),
      body: !loading
          ? Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: listproduct.length ?? 0,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? 3
                                    : 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: (0.48),
                          ),
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            return GestureDetector(
                              onTap: () {
                                print(index);
                                _addtocart(listproduct[index].brandId);
                              },
                              child: Container(
                                //color: Colors.white,

                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white),
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity, //75.0,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.5, //75.0,
                                      child: CachedNetworkImage(
                                        imageUrl: listproduct[index].image,
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(listproduct[index].brandName,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                          textAlign: TextAlign.center),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10, top: 5),
                                      child: Text(
                                          "Rp " +
                                              listproduct[index]
                                                  .brandPrice
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.orange),
                                          textAlign: TextAlign.center),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 8, top: 5),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_rounded,
                                            color: Colors.grey,
                                          ),
                                          Text(listproduct[index].city,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                              textAlign: TextAlign.center),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 8, top: 5),
                                      child: Row(
                                        children: [
                                          Icon(Icons.account_circle,
                                              color: Colors.grey),
                                          Text(listproduct[index].account,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                              textAlign: TextAlign.center),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: new BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Colors.blue),
                                      margin:
                                          EdgeInsets.only(left: 10, top: 10),
                                      child: Text("Ready Stock",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                          textAlign: TextAlign.center),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    left: MediaQuery.of(context).size.width / 3.3,
                    bottom: 20,
                    child: Center(
                        child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.category, color: Colors.grey),
                                  Text("Category",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.filter_alt_sharp,
                                      color: Colors.grey),
                                  Text("Filter",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )))
              ],
            )
          : Center(
              child: new CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            )),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
