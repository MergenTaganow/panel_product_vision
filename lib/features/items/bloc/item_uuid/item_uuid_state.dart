part of 'item_uuid_cubit.dart';

abstract class ItemUuidState {}

class ItemUuidInitial extends ItemUuidState {}

class ItemUuidSuccess extends ItemUuidState {
  final Item? item;
  final fetchedWithBarcode;
  ItemUuidSuccess(this.item, this.fetchedWithBarcode);
}

class ItemUuidFailed extends ItemUuidState {
  final Failure failure;
  ItemUuidFailed(this.failure);
}

class ItemUuidLoading extends ItemUuidState {}
