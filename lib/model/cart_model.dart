import 'dart:convert';

class cartItem {
  cartItem({
    this.cartId,
    
    this.image,
    this.brandName,
    this.brandPrice,
    this.quantity,
    this.weight
    // this.branches,
  });

  int cartId;
  String image;
  String brandName;
  int brandPrice;
  int quantity;
  double weight;
  //List<Branch> branches;

  factory cartItem.fromJson(Map<String, dynamic> json) => cartItem(
        cartId: json["cartId"] == null ? null : json["cartId"],
        image: json["image"] == null ? null : json["image"],
        brandName: json["brandName"] == null ? "" : json["brandName"],
        brandPrice: json["brandPrice"] == null ? "" : json["brandPrice"],
        quantity: json["quantity"] == null ? "" : json["quantity"],
        weight: json["weight"] == null ? null : json["weight"],
        //branches: json["branches"] == null ? null : List<Branch>.from(json["branches"].map((x) => Branch.fromJson(x))),
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data["brand_id"] = this.brandId;
  //   data["brand_name"] = this.brandName;
  //   data["brand_logo"] = this.brandPrice;
  //   // data["branches"] = this.branches;
  //   data["tags"] = this.city;

  //   return data;
  // }
}
