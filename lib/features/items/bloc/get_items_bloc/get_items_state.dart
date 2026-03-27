part of 'get_items_bloc.dart';

@immutable
sealed class GetItemsState {}

final class GetItemsInitial extends GetItemsState {}

final class GetItemsLoading extends GetItemsState {}
final class GetItemsPaginating extends GetItemsState {}

final class GetItemsFailed extends GetItemsState {
  final Failure failure;
  GetItemsFailed(this.failure);
}

final class GetItemsSuccess extends GetItemsState {
  final List<Item?> items;
  GetItemsSuccess(this.items);
}
