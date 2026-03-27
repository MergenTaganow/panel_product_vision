import 'dart:convert';




class Images {
  int? id;
  String? uuid;
  String? type;
  String? originalImg;
  String? bigImg;
  String? mediumImg;
  String? smallImg;
  bool? mainImage;

  Images(
      {this.id,
      this.type,
      this.originalImg,
      this.bigImg,
      this.mediumImg,
      this.smallImg,
      this.mainImage});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    type = json['type'];
    originalImg = json['originalImg'];
    bigImg = json['bigImg'];
    mediumImg = json['mediumImg'];
    smallImg = json['smallImg'];
    mainImage = json['mainImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['uuid'] = uuid;
    data['type'] = type;
    data['originalImg'] = originalImg;
    data['bigImg'] = bigImg;
    data['mediumImg'] = mediumImg;
    data['smallImg'] = smallImg;
    data['mainImage'] = mainImage;
    return data;
  }
}

class LastGroup {
  String? code;
  String? name;

  LastGroup({this.code, this.name});

  LastGroup.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}



class InnerStock {
  int nr;
  num onhand;
  InnerStock({
    required this.nr,
    required this.onhand,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'warehouseNr': nr,
      'onhand': onhand,
    };
  }

  factory InnerStock.fromMap(Map<String, dynamic> map) {
    return InnerStock(
      nr: map['warehouseNr'] as int,
      onhand: map['onhand'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory InnerStock.fromJson(String source) => InnerStock.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
