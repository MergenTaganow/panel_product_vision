part of 'tab_cubit.dart';

@immutable
abstract class TabState {
  final String i;
  const TabState(this.i);
}

class TabInitial extends TabState {
  const TabInitial(super.i);
}

class TabSuccess extends TabState {
  const TabSuccess(super.i);
}
