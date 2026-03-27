import 'dart:convert';

import 'package:flutter/foundation.dart';

class Query {
  String? keyword;
  bool? isActive;
  bool? isBlocked;
  bool? history;
  int? limit;
  int? startingYear;
  int? endingYear;
  int? offset;
  String? companyUuids;
  List<String?>? companyUuids2;
  List<String?>? departmentUuids;
  String? divisionUuids;
  String? jobUuids;
  List<String?>? groupUuids;
  List<String?>? topicUuids;
  List<String?>? employeeUuids;
  List<String?>? treeUuids;
  List<String?>? vacancyUuids;
  String? modelUuid;
  String? modelName;
  String? date;
  bool? lastWeek;
  bool? lasMonth;
  bool? skipMinus;
  int? scoreFrom;
  int? scoreTo;
  String? status;
  List? statuses;
  String? sortBy;
  String? sortAs;
  String? dateFrom;
  String? dateTo;
  String? orderBy;
  String? approachType;
  String? type;
  String? page;
  String? search;
  String? language;
  String? startDate;
  String? endDate;
  Query({
    this.keyword,
    this.isActive,
    this.isBlocked,
    this.startingYear,
    this.endingYear,
    this.history,
    this.limit,
    this.offset,
    this.companyUuids,
    this.companyUuids2,
    this.departmentUuids,
    this.divisionUuids,
    this.vacancyUuids,
    this.jobUuids,
    this.groupUuids,
    this.topicUuids,
    this.modelUuid,
    this.treeUuids,
    this.modelName,
    this.date,
    this.lastWeek,
    this.lasMonth,
    this.skipMinus,
    this.scoreFrom,
    this.scoreTo,
    this.status,
    this.statuses,
    this.sortBy,
    this.sortAs,
    this.dateFrom,
    this.dateTo,
    this.orderBy,
    this.approachType,
    this.employeeUuids,
    this.type,
    this.page,
    this.language,
    this.search,
    this.startDate,
    this.endDate,
  });

  Query copyWith({
    String? keyword,
    bool? isActive,
    bool? isBlocked,
    bool? history,
    int? limit,
    int? offset,
    int? startingYear,
    int? endingYear,
    String? companyUuids,
    List<String?>? companyUuids2,
    List<String?>? departmentUuids,
    List<String?>? vacancyUuids,
    String? divisionUuids,
    String? jobUuids,
    List<String?>? groupUuids,
    List<String?>? topicUuids,
    List<String?>? employeeUuids,
    List<String?>? treeUuids,
    String? modelUuid,
    String? modelName,
    String? date,
    bool? lastWeek,
    bool? lasMonth,
    bool? skipMinus,
    int? scoreFrom,
    int? scoreTo,
    String? status,
    List? statuses,
    String? sortBy,
    String? sortAs,
    String? dateFrom,
    String? dateTo,
    String? orderBy,
    String? approachType,
    String? type,
    String? page,
    String? language,
    String? search,
    String? startDate,
    String? endDate,
  }) {
    return Query(
      keyword: keyword ?? this.keyword,
      isActive: isActive ?? this.isActive,
      isBlocked: isBlocked ?? this.isBlocked,
      history: history ?? this.history,
      limit: limit ?? this.limit,
      startingYear: startingYear ?? this.startingYear,
      endingYear: endingYear ?? this.endingYear,
      offset: offset ?? this.offset,
      companyUuids: companyUuids ?? this.companyUuids,
      companyUuids2: companyUuids2 ?? this.companyUuids2,
      departmentUuids: departmentUuids ?? this.departmentUuids,
      divisionUuids: divisionUuids ?? this.divisionUuids,
      vacancyUuids: vacancyUuids ?? this.vacancyUuids,
      treeUuids: treeUuids ?? this.treeUuids,
      jobUuids: jobUuids ?? this.jobUuids,
      groupUuids: groupUuids ?? this.groupUuids,
      topicUuids: topicUuids ?? this.topicUuids,
      employeeUuids: employeeUuids ?? this.employeeUuids,
      modelUuid: modelUuid ?? this.modelUuid,
      modelName: modelName ?? this.modelName,
      date: date ?? this.date,
      lastWeek: lastWeek ?? this.lastWeek,
      lasMonth: lasMonth ?? this.lasMonth,
      skipMinus: skipMinus ?? this.skipMinus,
      scoreFrom: scoreFrom ?? this.scoreFrom,
      scoreTo: scoreTo ?? this.scoreTo,
      status: status ?? this.status,
      statuses: statuses ?? this.statuses,
      sortBy: sortBy ?? this.sortBy,
      sortAs: sortAs ?? this.sortAs,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      orderBy: orderBy ?? this.orderBy,
      approachType: approachType ?? this.approachType,
      type: type ?? this.type,
      page: page ?? this.page,
      language: language ?? this.language,
      search: search ?? this.search,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (keyword != null) 'keyword': keyword,
      if (isActive != null) 'isActive': isActive,
      if (isBlocked != null) 'isBlocked': isBlocked,
      if (history != null) 'history': history,
      if (limit != null) 'limit': limit,
      if (startingYear != null) 'startingYear': startingYear,
      if (endingYear != null) 'endingYear': endingYear,
      if (offset != null) 'offset': offset,
      if (companyUuids != null || companyUuids2 != null)
        'companyUuids[]': [if (companyUuids != null) companyUuids, ...?companyUuids2],
      if (departmentUuids != null) 'departmentUuids[]': departmentUuids,
      if (divisionUuids != null) 'divisionUuids[]': divisionUuids,
      if (treeUuids != null) 'treeUuids[]': treeUuids,
      if (jobUuids != null) 'jobUuids[]': jobUuids,
      if (groupUuids != null) 'groupUuids[]': groupUuids,
      if (topicUuids != null) 'topicUuids[]': topicUuids,
      if (employeeUuids != null) 'employeeUuids[]': employeeUuids,
      if (vacancyUuids != null) 'vacancyUuids[]': vacancyUuids,
      if (modelUuid != null) 'modelUuid': modelUuid,
      if (modelName != null) 'modelName': modelName,
      if (date != null) 'date': date,
      if (lastWeek != null) 'lastWeek': lastWeek,
      if (lasMonth != null) 'lasMonth': lasMonth,
      if (scoreFrom != null) 'scoreFrom': scoreFrom,
      if (scoreTo != null) 'scoreTo': scoreTo,
      if (status != null) 'status': status,
      if (statuses != null) 'statuses[]': statuses,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortAs != null) 'sortAs': sortAs,
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
      if (orderBy != null) 'orderBy': orderBy,
      if (skipMinus != null) 'skipMinus': skipMinus,
      if (approachType != null) 'approachType': approachType,
      if (type != null) 'type': type,
      if (page != null) 'page': page,
      if (language != null) 'language': language,
      if (search != null) 'search': search,
      if (endDate != null) 'endDate': endDate,
      if (startDate != null) 'startDate': startDate,
    };
  }

  factory Query.fromMap(Map<String, dynamic> map) {
    return Query(
      keyword: map['keyword'] != null ? map['keyword'] as String : null,
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
      isBlocked: map['isBlocked'] != null ? map['isBlocked'] as bool : null,
      history: map['history'] != null ? map['history'] as bool : null,
      limit: map['limit'] != null ? map['limit'] as int : null,
      startingYear: map['startingYear'] != null ? map['startingYear'] as int : null,
      endingYear: map['endingYear'] != null ? map['endingYear'] as int : null,
      offset: map['offset'] != null ? map['offset'] as int : null,
      companyUuids: map['companyUuids'] != null ? map['companyUuids'] as String : null,
      departmentUuids: map['departmentUuids'],
      divisionUuids: map['divisionUuids'] != null ? map['divisionUuids'] as String : null,
      treeUuids: map['treeUuids'] != null ? map['treeUuids'] as List<String> : null,
      jobUuids: map['jobUuids'] != null ? map['jobUuids'] as String : null,
      employeeUuids: map['employeeUuids'],
      groupUuids: map['groupUuids'],
      topicUuids: map['topicUuids'],
      modelUuid: map['modelUuid'] != null ? map['modelUuid'] as String : null,
      modelName: map['modelName'] != null ? map['modelName'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      lastWeek: map['lastWeek'] != null ? map['lastWeek'] as bool : null,
      lasMonth: map['lasMonth'] != null ? map['lasMonth'] as bool : null,
      scoreFrom: map['scoreFrom'] != null ? map['scoreFrom'] as int : null,
      scoreTo: map['scoreTo'] != null ? map['scoreTo'] as int : null,
      status: map['status'] != null ? map['status'] as String : null,
      statuses: map['statuses'],
      sortBy: map['sortBy'] != null ? map['sortBy'] as String : null,
      sortAs: map['sortAs'] != null ? map['sortAs'] as String : null,
      dateFrom: map['dateFrom'] != null ? map['dateFrom'] as String : null,
      dateTo: map['dateTo'] != null ? map['dateTo'] as String : null,
      orderBy: map['orderBy'] != null ? map['orderBy'] as String : null,
      approachType: map['approachType'] != null ? map['approachType'] as String : null,
      skipMinus: map['skipMinus'],
      type: map['type'],
      page: map['page'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Query.fromJson(String source) =>
      Query.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Query(keyword: $keyword, isActive: $isActive, isBlocked: $isBlocked, history: $history, limit: $limit, offset: $offset, companyUuids: $companyUuids, departmentUuids: $departmentUuids, divisionUuids: $divisionUuids, jobUuids: $jobUuids, groupUuids: $groupUuids, topicUuids : $topicUuids, modelUuid: $modelUuid, modelName: $modelName, date: $date, lastWeek: $lastWeek, lasMonth: $lasMonth, skipMinus: $skipMinus, scoreFrom: $scoreFrom, scoreTo: $scoreTo, status: $status, statuses: $statuses, sortBy: $sortBy, sortAs: $sortAs, dateFrom: $dateFrom, dateTo: $dateTo, orderBy: $orderBy, approachType: $approachType)';
  }

  @override
  bool operator ==(covariant Query other) {
    if (identical(this, other)) return true;

    return other.keyword == keyword &&
        other.isActive == isActive &&
        other.isBlocked == isBlocked &&
        other.history == history &&
        other.limit == limit &&
        other.offset == offset &&
        other.companyUuids == companyUuids &&
        listEquals(other.departmentUuids, departmentUuids) &&
        other.divisionUuids == divisionUuids &&
        other.jobUuids == jobUuids &&
        listEquals(other.groupUuids, groupUuids) &&
        listEquals(other.topicUuids, topicUuids) &&
        listEquals(other.employeeUuids, employeeUuids) &&
        listEquals(other.vacancyUuids, vacancyUuids) &&
        other.modelUuid == modelUuid &&
        other.modelName == modelName &&
        other.date == date &&
        other.lastWeek == lastWeek &&
        other.lasMonth == lasMonth &&
        other.skipMinus == skipMinus &&
        other.scoreFrom == scoreFrom &&
        other.scoreTo == scoreTo &&
        other.status == status &&
        other.statuses == statuses &&
        other.sortBy == sortBy &&
        other.sortAs == sortAs &&
        other.dateFrom == dateFrom &&
        other.dateTo == dateTo &&
        other.type == type &&
        other.approachType == approachType &&
        other.orderBy == orderBy;
  }

  @override
  int get hashCode {
    return keyword.hashCode ^
        isActive.hashCode ^
        isBlocked.hashCode ^
        history.hashCode ^
        limit.hashCode ^
        offset.hashCode ^
        companyUuids.hashCode ^
        departmentUuids.hashCode ^
        divisionUuids.hashCode ^
        jobUuids.hashCode ^
        groupUuids.hashCode ^
        vacancyUuids.hashCode ^
        topicUuids.hashCode ^
        employeeUuids.hashCode ^
        modelUuid.hashCode ^
        modelName.hashCode ^
        date.hashCode ^
        lastWeek.hashCode ^
        lasMonth.hashCode ^
        skipMinus.hashCode ^
        scoreFrom.hashCode ^
        scoreTo.hashCode ^
        status.hashCode ^
        statuses.hashCode ^
        sortBy.hashCode ^
        sortAs.hashCode ^
        dateFrom.hashCode ^
        dateTo.hashCode ^
        type.hashCode ^
        orderBy.hashCode;
  }
}
