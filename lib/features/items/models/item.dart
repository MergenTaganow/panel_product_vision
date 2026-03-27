import 'dart:convert';

import 'found_item.dart';
import 'group.dart';

class Item {
  String? uuid;
  String? code;
  String? barcode;
  String? specode;
  String? name;
  String? erpName;
  String? brandImg;
  int? cartAmount;
  List<Images?>? images;
  String? info;
  bool? isFavourite;
  bool? active;
  Group? lastGroup;
  Group? mainGroup;
  num? salesLimitQuantity;
  String? unit;
  String? video;
  num? price;
  String? currency;
  num? discount;
  String? discountType;
  String? paretto;
  String? bigImg;
  String? mediumImg;
  String? smallImg;
  int? countOfComplect;
  bool? isNew;
  num? unitCount;
  int? lastPurchaseAmount;
  num? lastPurchaseTMT;
  num? lastPurchaseUSD;
  num? lastPurchaseID;
  String? lastPurchaseIDCode;
  DateTime? lastPurchaseDate;
  int? firstPurchaseAmount;
  num? firstPurchaseTMT;
  num? firstPurchaseUSD;
  num? firstPurchaseID;
  String? firstPurchaseIDCode;
  DateTime? firstPurchaseDate;
  bool? isWeeklyTrend;
  bool? isMonthlyTrend;
  num? rating;
  num? countOfSales;
  num? countOfFiches;
  num? sumOfSale;
  int? commentCount;
  List<InnerStock>? stocks;
  DateTime? beginDate; //will come only for repriced items
  String? brand;
  String? brandUuid;
  String? brandImage;
  String? blurImg;

  Item({
    this.uuid,
    this.code,
    this.barcode,
    this.specode,
    this.name,
    this.erpName,
    this.brandImg,
    this.cartAmount,
    this.images,
    this.active,
    this.info,
    this.video,
    this.isFavourite,
    this.lastGroup,
    this.mainGroup,
    this.salesLimitQuantity,
    this.unit,
    this.price,
    this.currency,
    this.discount,
    this.discountType,
    this.paretto,
    this.bigImg,
    this.mediumImg,
    this.smallImg,
    this.countOfComplect,
    this.isNew,
    this.unitCount,
    this.lastPurchaseAmount,
    this.lastPurchaseTMT,
    this.lastPurchaseUSD,
    this.lastPurchaseID,
    this.lastPurchaseIDCode,
    this.lastPurchaseDate,
    this.isWeeklyTrend,
    this.isMonthlyTrend,
    this.commentCount,
    this.rating,
    this.stocks,
    this.countOfSales,
    this.countOfFiches,
    this.sumOfSale,
    this.firstPurchaseAmount,
    this.firstPurchaseDate,
    this.firstPurchaseID,
    this.firstPurchaseIDCode,
    this.firstPurchaseTMT,
    this.firstPurchaseUSD,
    this.beginDate,
    this.brand,
    this.brandImage,
    this.brandUuid,
    this.blurImg,
  });
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      specode: map['specode'] != null ? map['specode'] as String : null,
      code: map['code'] != null ? map['code'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      erpName: map['erpName'] != null ? map['erpName'] as String : null,
      brandImg: map['brandImg'] != null ? map['brandImg'] as String : null,
      active: map['active'] != null ? map['active'] == true : map['status'] == 'active',
      cartAmount: map['cartAmount'] != null ? map['cartAmount'] as int : null,
      images: map['images'] != null
          ? (map['images'] as List).map((element) => Images.fromJson(element)).toList()
          : <Images?>[],
      video: map['video'] != null ? map['video'] as String : null,
      info: map['info'] != null ? map['info'] as String : null,
      lastGroup: map['lastGroup'] != null
          ? (map['lastGroup'] is String)
              ? Group.fromString(map['lastGroup'])
              : Group.fromJson(map['lastGroup'])
          : null,
      mainGroup: map['mainGroup'] != null
          ? (map['mainGroup'] is String)
              ? Group.fromString(map['mainGroup'])
              : Group.fromJson(map['mainGroup'])
          : null,
      salesLimitQuantity:
          map['salesLimitQuantity'] != null ? map['salesLimitQuantity'] as int : null,
      unit: map['unit'] != null ? map['unit'] as String : null,
      price: map['price'] != null ? map['price'] as num : null,
      currency: map['currency'] != null ? map['currency'] as String : 'TMT',
      discount: map['discount'] != null ? map['discount'] as num : null,
      discountType: map['discountType'] != null ? map['discountType'] as String : null,
      paretto: map['paretto'] != null ? map['paretto'] as String : null,
      bigImg: map['bigImg'] != null ? map['bigImg'] as String : null,
      mediumImg: map['mediumImg'] != null ? map['mediumImg'] as String : null,
      smallImg: map['smallImg'] != null ? map['smallImg'] as String : null,
      countOfComplect: map['countOfComplect'] != null ? map['countOfComplect'] as int : null,
      isNew: map['isNew'] != null ? map['isNew'] as bool : null,
      unitCount: map['unitCount'] != null ? map['unitCount'] as num : null,
      lastPurchaseTMT: map['lastPurchaseTMT'] != null ? map['lastPurchaseTMT'] as num : null,
      lastPurchaseUSD: map['lastPurchaseUSD'] != null ? map['lastPurchaseUSD'] as num : null,
      lastPurchaseID: map['lastPurchaseID'] != null ? map['lastPurchaseID'] as num : null,
      lastPurchaseIDCode:
          map['lastPurchaseIDCode'] != null ? map['lastPurchaseIDCode'] as String : null,
      lastPurchaseDate:
          map['lastPurchaseDate'] != null ? DateTime.tryParse(map['lastPurchaseDate']) : null,
      firstPurchaseTMT: map['firstPurchaseTMT'] != null ? map['firstPurchaseTMT'] as num : null,
      firstPurchaseUSD: map['firstPurchaseUSD'] != null ? map['firstPurchaseUSD'] as num : null,
      firstPurchaseID: map['firstPurchaseID'] != null ? map['firstPurchaseID'] as num : null,
      firstPurchaseIDCode:
          map['firstPurchaseIDCode'] != null ? map['firstPurchaseIDCode'] as String : null,
      firstPurchaseDate:
          map['firstPurchaseDate'] != null ? DateTime.tryParse(map['firstPurchaseDate']) : null,
      isMonthlyTrend: map['isMonthlyTrend'] != null ? map['isMonthlyTrend'] as bool : null,
      isWeeklyTrend: map['isWeeklyTrend'] != null ? map['isWeeklyTrend'] as bool : null,
      commentCount: map['commentCount'] != null ? map['commentCount'] as int : null,
      rating: map['rating'] != null ? map['rating'] as num : null,
      stocks: map['stocks'] != null
          ? (map['stocks'] as List).map((e) => InnerStock.fromMap(e)).toList()
          : null,
      countOfSales: map['countOfSales'] != null ? map['countOfSales'] as num : null,
      countOfFiches: map['countOfFiches'] != null ? map['countOfFiches'] as num : null,
      sumOfSale: map['sumOfSale'] != null ? map['sumOfSale'] as num : null,
      beginDate: map['beginDate'] != null ? DateTime.tryParse(map['beginDate']) : null,
      brand: map['brand'] is String ? map['brand'] : null,
      brandUuid: map['brandUuid'],
      brandImage: map['brandImage'],
      blurImg: map['blurImg'],
    );
  }
  Item.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    specode = json['specode'] == '' ? null : json['specode'];
    code = json['code'];
    name = json['name'];
    erpName = json['erpName'];

    brand = json['brand'] is String ? json['brand'] : null;
    brandImg = json['brandImage'];
    active = json['active'] != null ? json['active'] == true : json['status'] == 'active';

    cartAmount = json['cartAmount'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    video = json['video'];
    info = json['info'];
    lastGroup = json['lastGroup'];
    mainGroup = json['mainGroup'];
    salesLimitQuantity = json['salesLimitQuantity'];
    unit = json['unit'];
    price = json['price'];
    currency = json['currency'] ?? 'TMT';
    discount = json['discount'];
    discountType = json['discountType'];
    paretto = json['paretto'];
    bigImg = json['bigImg'];
    mediumImg = json['mediumImg'];
    smallImg = json['smallImg'];
    countOfComplect = json['countOfComplect'];
    isNew = json['isNew'];
    unitCount = json['unitCount'];
    lastPurchaseAmount = json['lastPurchaseAmount'];
    lastPurchaseTMT = json['lastPurchaseTMT'];
    lastPurchaseUSD = json['lastPurchaseUSD'];
    lastPurchaseID = json['lastPurchaseID'];
    lastPurchaseIDCode = json['lastPurchaseIDCode'];
    lastPurchaseDate = json['lastPurchaseDate'];
    firstPurchaseAmount = json['firstPurchaseAmount'];
    firstPurchaseTMT = json['firstPurchaseTMT'];
    firstPurchaseUSD = json['firstPurchaseUSD'];
    firstPurchaseID = json['firstPurchaseID'];
    firstPurchaseIDCode = json['firstPurchaseIDCode'];
    firstPurchaseDate = json['firstPurchaseDate'];
    isMonthlyTrend = json['isMonthlyTrend'];
    isWeeklyTrend = json['isWeeklyTrend'];
    commentCount = json['commentCount'];
    rating = json['rating'];
    countOfSales = json['countOfSales'];
    countOfFiches = json['countOfFiches'];
    sumOfSale = json['sumOfSale'];
    beginDate = json['beginDate'] != null ? DateTime.tryParse(json['beginDate']) : null;
    brand = json['brand'];
    brandUuid = json['brandUuid'];
    brandImage = json['brandImage'];
    blurImg = json['blurImg'];
  }
  getPrice() {
    // if (unitCount != 1) {
    //   return '${currency ?? 'TMT'} ${((price ?? 0) * (unitCount ?? 1)).toStringAsFixed(2)}';
    // }
    // var oldPriceSystem = (sl<OldPriceSystemCubit>().state as OldPriceSystemSuccess).oldPrice;
    if (price != null && currency == 'TMT') {
      return '${(price! * 5).toStringAsFixed(2)} k TMT';
    }

    return '${price?.toStringAsFixed(2)} ${currency ?? 'TMT'}';
  }

  getDiscountPrice() {
    if (discount != null && price != null) {
      // var oldPriceSystem = (sl<OldPriceSystemCubit>().state as OldPriceSystemSuccess).oldPrice;
      if (price != null && currency == 'TMT') {
        var discountPrice = (price! - (price! * discount! / 100)) * 5;
        return '${discountPrice.toStringAsFixed(2)} k TMT';
      }

      var discountPrice = price! - (price! * discount! / 100);
      return '${discountPrice.toStringAsFixed(2)} ${currency ?? 'TMT'}';
    }
  }

  getPriceTotal() {
    if (currency == 'TMT') {
      // var oldPriceSystem = (sl<OldPriceSystemCubit>().state as OldPriceSystemSuccess).oldPrice;
      // if (oldPriceSystem) {
      //   return '${((price ?? 1) * (unitCount ?? 1) * 5).toStringAsFixed(2)} k TMT';
      // }

      return '${((price ?? 1) * (unitCount ?? 1)).toStringAsFixed(2)} ${currency ?? 'TMT'}';
    } else {
      return '${((price ?? 1) * (unitCount ?? 1)).toStringAsFixed(4)} ${currency ?? 'USD'}';
    }
  }

  getDiscountTotal() {
    if (discount != null && price != null) {
      var discountPrice = price! - (price! * discount! / 100);
      if (currency == 'TMT') {
        // var oldPriceSystem = (sl<OldPriceSystemCubit>().state as OldPriceSystemSuccess).oldPrice;
        // if (oldPriceSystem) {
        //   return '${((discountPrice) * (unitCount ?? 1) * 5).toStringAsFixed(2)} ${currency ?? 'TMT'}';
        // }
        return '${((discountPrice) * (unitCount ?? 1)).toStringAsFixed(2)} ${currency ?? 'TMT'}';
      } else {
        return '${((discountPrice) * (unitCount ?? 1)).toStringAsFixed(4)} ${currency ?? 'USD'}';
      }
    }
  }

  String getUnit() {
    return '$unitCount $unit';
  }

  String getSingleUnit() {
    // return '${(unitCount ?? 0) < 1 ? unitCount : '1'} $unit';
    return '1 $unit';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['uuid'] = uuid;
    data['specode'] = specode;
    data['code'] = code;
    data['barcode'] = barcode;
    data['name'] = name;
    data['erpName'] = erpName;
    data['brandImg'] = brandImg;
    data['cartAmount'] = cartAmount;
    if (images != null) {
      data['images'] = images!.map((v) => v?.toJson()).toList();
    }
    data['info'] = info;
    data['isFavourite'] = isFavourite;
    data['status'] = active;
    data['lastGroup'] = lastGroup;
    data['mainGroup'] = mainGroup;
    data['salesLimitQuantity'] = salesLimitQuantity;
    data['unit'] = unit;
    data['video'] = video;
    data['price'] = price;
    data['currency'] = currency;
    data['discount'] = discount;
    data['discountType'] = discountType;
    data['paretto'] = paretto;
    data['bigImg'] = bigImg;
    data['mediumImg'] = mediumImg;
    data['smallImg'] = smallImg;
    data['countOfComplect'] = countOfComplect;
    data['isNew'] = isNew;
    data['unitCount'] = unitCount;
    data['lastPurchaseAmount'] = lastPurchaseAmount;
    data['lastPurchaseTMT'] = lastPurchaseTMT;
    data['lastPurchaseUSD'] = lastPurchaseUSD;
    data['lastPurchaseID'] = lastPurchaseID;
    data['lastPurchaseIDCode'] = lastPurchaseIDCode;
    data['lastPurchaseDate'] = lastPurchaseDate;
    data['blurImg'] = blurImg;
    return data;
  }
}

class Items {
  List<Item> all;
  Items({
    required this.all,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'all': all.map((x) => x.toJson()).toList(),
    };
  }

  factory Items.fromMap(Map<String, dynamic> map) {
    return Items(
      all: List<Item>.from(
        (map as List<Map<String, dynamic>>).map<Item>(
          (x) => Item.fromJson(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Items.fromJson(String source) =>
      Items.fromMap(json.decode(source) as Map<String, dynamic>);
}
