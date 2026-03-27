import 'dart:convert';

class AccessibleDivision {
  int? nr;
  String? name;
  String? uuid;
  String? code;
  bool selected;
  AccessibleDivision({
    required this.nr,
    required this.name,
    required this.selected,
    this.uuid,
    this.code,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nr': nr,
      'name': name,
      'selected': selected,
      'uuid': uuid,
      'code': code,
    };
  }

  factory AccessibleDivision.fromMap(Map<String, dynamic> map) {
    return AccessibleDivision(
      nr: map['nr'],
      name: map['name'],
      uuid: map['uuid'],
      code: map['code'] != null ? map['code'] as String : null,
      selected: true,
    );
  }

  String toJson() => json.encode(toMap());

  factory AccessibleDivision.fromJson(String source) =>
      AccessibleDivision.fromMap(json.decode(source) as Map<String, dynamic>);

  ///this was made for selecting all divisions
  static allDivision(lg) {
    return AccessibleDivision(nr: 1111111111111, name: lg.all, selected: true);
  }
}
