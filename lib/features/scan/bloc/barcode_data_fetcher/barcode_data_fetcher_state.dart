part of 'barcode_data_fetcher_cubit.dart';

@immutable
sealed class BarcodeDataFetcherState {}

final class BarcodeDataFetcherInitial extends BarcodeDataFetcherState {}

final class BarcodeDataFetcherLoading extends BarcodeDataFetcherState {}

final class BarcodeDataFetcherFailed extends BarcodeDataFetcherState {}

final class BarcodeDataWasItem extends BarcodeDataFetcherState {
  final Item? item;
  BarcodeDataWasItem(this.item);
}
