import 'dart:convert';

class produkItem {
  produkItem(
      {this.brandId,
      this.image,
      this.brandName,
      this.brandPrice,
      this.city,
      this.account,
      this.weight
      // this.branches,
      });

  int brandId;
  String image;
  String brandName;
  int brandPrice;
  String city;
  String account;
  double weight;
  //List<Branch> branches;

  factory produkItem.fromJson(Map<String, dynamic> json) => produkItem(
        brandId: json["brandId"] == null ? null : json["brandId"],
        image: json["image"] == null ? null : json["image"],
        brandName: json["brandName"] == null ? "" : json["brandName"],
        brandPrice: json["brandPrice"] == null ? "" : json["brandPrice"],
        city: json["city"] == null ? "" : json["city"],
        account: json["account"] == null ? null : json["account"],
        weight: json["weight"] == null ? "" : json["weight"],
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
