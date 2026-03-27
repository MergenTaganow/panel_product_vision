
import 'package:flutter/material.dart';

class Group {
  String? uuid;
  String? code;
  String? name;
  String? nameSingularTm;
  String? nameSingularEng;
  String? nameSingularRu;
  List<LastGroup>? lastGroups;

  Group(
      {this.uuid,
      this.code,
      this.name,
      this.nameSingularTm,
      this.nameSingularEng,
      this.nameSingularRu,
      this.lastGroups});

  Group.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    code = json['code'];
    name = json['name'];
    nameSingularEng = json['nameSingularEng'];
    nameSingularRu = json['nameSingularRu'];
    nameSingularTm = json['nameSingularTm'];
    lastGroups = json['lastGroups'] != null
        ? (json['lastGroups'] as List).map((e) => LastGroup.fromJson(e)).toList()
        : [];
  }
  Group.fromString(String name) {
    name = name;
  }

  String getName(BuildContext context) {
    String code =
        // AppLocalizations.of(context)?.localeName ??
        'tr';
    if (code == 'tr') {
      return nameSingularTm ?? nameSingularEng ?? name ?? '';
    } else if (code == 'ru') {
      return nameSingularRu ?? nameSingularEng ?? name ?? '';
    } else if (code == 'en') {
      return nameSingularEng ?? nameSingularTm ?? name ?? '';
    } else {
      return '';
    }
  }
}

class LastGroup {
  String? uuid;
  String? code;
  String? name;
  String? nameSingularTm;
  String? nameSingularEng;
  String? nameSingularRu;

  LastGroup(
      {this.uuid,
      this.code,
      this.name,
      this.nameSingularTm,
      this.nameSingularEng,
      this.nameSingularRu});
  LastGroup.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    code = json['code'];
    name = json['name'];
    nameSingularEng = json['nameSingularEng'];
    nameSingularRu = json['nameSingularRu'];
    nameSingularTm = json['nameSingularTm'];
  }
  String getName(BuildContext context) {
    String code =
        // AppLocalizations.of(context)?.localeName ??
        'tr';
    if (code == 'tr') {
      return nameSingularTm ?? nameSingularEng ?? name ?? '';
    } else if (code == 'ru') {
      return nameSingularRu ?? nameSingularEng ?? name ?? '';
    } else if (code == 'en') {
      return nameSingularEng ?? nameSingularTm ?? name ?? '';
    } else {
      return '';
    }
  }
}
