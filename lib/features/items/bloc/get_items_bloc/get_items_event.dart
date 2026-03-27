part of 'get_items_bloc.dart';

@immutable
sealed class GetItemsEvent {}

class GetItems extends GetItemsEvent {
  final Query? query;
  GetItems({ this.query});
}

class PagItems extends GetItemsEvent {
  final Query? query;
  PagItems({this.query});
}
