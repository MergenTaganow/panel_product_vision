import 'dart:convert';

import 'accessible_divisions.dart';

class User {
  String? token;
  String? uuid;
  String? fullName;
  String? name;
  String? username;
  bool? negativeStockAccess;
  bool? stock0Access;
  bool? stockAnalyzeAccess;
  bool? allTrucks;
  bool? trucks;
  bool? screenshotAccess;
  bool? saleAnalyzeAccess;
  bool? saleAnalyzeWithAmount;
  bool? printLabel;
  bool? alternativeView;
  bool? crossSaleView;
  bool? substituteView;
  bool? stockPermissions;
  bool? clientSaleAnalyze;
  bool? clientSaleAnalyzeWithAmount;
  bool? viewPurchaseInfo;
  List? sectionCode;
  List? client;
  List? sync;
  List? alManufactory;
  List? mbManufactory;
  List<AccessibleDivision>? accessibleDivisions;

  User({
    this.token,
    this.uuid,
    this.fullName,
    this.name,
    this.allTrucks,
    this.trucks,
    this.negativeStockAccess,
    this.stock0Access,
    this.stockAnalyzeAccess,
    this.screenshotAccess,
    this.saleAnalyzeAccess,
    this.accessibleDivisions,
    this.saleAnalyzeWithAmount,
    this.printLabel,
    this.alternativeView,
    this.crossSaleView,
    this.substituteView,
    this.sectionCode,
    this.stockPermissions,
    this.client,
    this.username,
    this.clientSaleAnalyze,
    this.viewPurchaseInfo,
    this.sync,
    this.alManufactory,
    this.mbManufactory,
    this.clientSaleAnalyzeWithAmount,
  });

  User.fromJson(Map<String, dynamic> json) {
    token = json['token'] != null ? json['token'] as String : null;
    uuid = json['uuid'] != null ? json['uuid'] as String : null;
    fullName = json['fullName'] != null ? json['fullName'] as String : null;
    username = json['username'] != null ? json['username'] as String : null;
    name = json['name'] != null ? json['name'] as String : null;
    allTrucks = json['item'].contains('allTrucks') ? true : false;
    trucks = json['item'].contains('trucks') ? true : false;
    saleAnalyzeAccess = json['item'].contains('saleAnalyze') ? true : false;
    negativeStockAccess = json['item'].contains('negativeStock') ? true : false;
    stock0Access = json['item'].contains('stock0') ? true : false;
    stockAnalyzeAccess = json['item'].contains('stockAnalyze') ? true : false;
    screenshotAccess = json['item'].contains('screenshot') ? true : false;
    viewPurchaseInfo = json['item'].contains('viewPurchaseInfo') ? true : false;
    saleAnalyzeWithAmount = json['item'].contains('saleAnalyzeWithAmount') ? true : false;
    alternativeView = json['item'].contains('alternativeView') ? true : false;
    crossSaleView = json['item'].contains('crossSaleView') ? true : false;
    substituteView = json['item'].contains('substituteView') ? true : false;
    printLabel = json['item'].contains('printLabel') ? true : false;
    clientSaleAnalyze = json['item'].contains('clientSaleAnalyze') ? true : false;
    clientSaleAnalyzeWithAmount =
        json['item'].contains('clientSaleAnalyzeWithAmount') ? true : false;
    stockPermissions =
        json['stockPermissions'] != null ? (json['stockPermissions'] as bool) : false;
    sectionCode =
        (json['sectionCode'] != null ? json['sectionCode'] as List : []).isNotEmpty
            ? json['sectionCode']
            : [];
    sync = (json['sync'] != null ? json['sync'] as List : []).isNotEmpty ? json['sync'] : [];
    alManufactory =
        (json['alManufactory'] != null ? json['alManufactory'] as List : []).isNotEmpty
            ? json['alManufactory']
            : [];
    mbManufactory =
        (json['mbManufactory'] != null ? json['mbManufactory'] as List : []).isNotEmpty
            ? json['mbManufactory']
            : [];
    client =
        (json['client'] != null ? json['client'] as List : []).isNotEmpty ? json['client'] : [];
    accessibleDivisions =
        (json.containsKey("divisions"))
            ? (json['divisions'] as List).map((e) => AccessibleDivision.fromMap(e)).toList()
            : [];
  }

  String toJson() {
    final Map<String, dynamic> data = {};
    data['token'] = token;
    data['uuid'] = uuid;
    data['fullName'] = fullName;
    data['name'] = name;
    data['username'] = username;
    data['item'] = [];
    if (negativeStockAccess ?? false) data['item'].add('negativeStock');
    if (allTrucks ?? false) data['item'].add('allTrucks');
    if (trucks ?? false) data['item'].add('trucks');
    if (screenshotAccess ?? false) data['item'].add('screenshot');
    if (stock0Access ?? false) data['item'].add('stock0');
    if (stockAnalyzeAccess ?? false) data['item'].add('stockAnalyze');
    if (saleAnalyzeAccess ?? false) data['item'].add('saleAnalyze');
    if (saleAnalyzeWithAmount ?? false) {
      data['item'].add('saleAnalyzeWithAmount');
    }
    if (printLabel ?? false) data['item'].add('printLabel');
    if (alternativeView ?? false) data['item'].add('alternativeView');
    if (crossSaleView ?? false) data['item'].add('crossSaleView');
    if (viewPurchaseInfo ?? false) data['item'].add('viewPurchaseInfo');
    if (substituteView ?? false) data['item'].add('substituteView');
    if (clientSaleAnalyze ?? false) data['item'].add('clientSaleAnalyze');
    if (clientSaleAnalyzeWithAmount ?? false) {
      data['item'].add('clientSaleAnalyzeWithAmount');
    }
    if (sectionCode?.isNotEmpty ?? false) data['sectionCode'] = sectionCode;
    if (sync?.isNotEmpty ?? false) data['sync'] = sync;
    if (alManufactory?.isNotEmpty ?? false) data['alManufactory'] = alManufactory;
    if (mbManufactory?.isNotEmpty ?? false) data['mbManufactory'] = mbManufactory;
    if (client?.isNotEmpty ?? false) data['client'] = client;
    if (stockPermissions ?? false) data['stockPermissions'] = stockPermissions;

    data['divisions'] = accessibleDivisions?.map((e) => e.toMap()).toList();

    return jsonEncode(data);
  }
}

class AccessTypes {
  static String update = 'update';
  static String create = 'create';
}
