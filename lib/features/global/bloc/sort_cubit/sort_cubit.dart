import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sort_state.dart';

class SortCubit extends Cubit<SortState> {
  SortCubit() : super(SortSuccess(null));
  Map<String, Sort?> sortMap = {};

  selectSort({required String key, Sort? newSort}) {
    sortMap[key] = newSort;
    emit.call(SortSuccess(sortMap));
  }

  static String itemSort = 'itemSort';
  static String mbOrderSort = 'mbOrderSort';
}

class Sort {
  String? sortBy;
  String? sortAs;
  String? text;

  Sort({this.text, this.sortBy, this.sortAs});
}
