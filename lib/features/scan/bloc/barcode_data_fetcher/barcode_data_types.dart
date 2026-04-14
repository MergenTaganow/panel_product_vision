import '../../../items/models/item.dart';

class BarcodeDataTypes {
  final BroadcastResponseModelTypes type;
  final Item? item;
  BarcodeDataTypes({required this.type, this.item});
}

enum BroadcastResponseModelTypes { item }
