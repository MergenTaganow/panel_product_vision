
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tab_state.dart';

class TabCubit extends Cubit<TabState> {
  TabCubit() : super(const TabInitial(''));
  
  navigate(String tab) {
    emit.call(TabSuccess(tab));
  }
}
