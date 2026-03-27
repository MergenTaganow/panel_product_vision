import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'boolean_filter_state.dart';

class BooleanFilterCubit extends Cubit<BooleanFilterState> {
  BooleanFilterCubit() : super(BooleanFilterSuccess(const {}));
  Map<String, bool?> savedMap = {};

  select(String key, bool? value) {
    savedMap[key] = value;
    emit.call(BooleanFilterSuccess(savedMap));
  }

  static String al_dashboard_overDue = 'al_dashboard_overDue';
  static String al_delivered_orders = 'al_delivered_orders';
  static String al_reworked_orders = 'al_reworked_orders';
  static String mb_reworked_orders = 'mb_reworked_orders';
}
