part of 'broadcast_cubit.dart';

@immutable
abstract class BroadcastState {}

class BroadcastInitial extends BroadcastState {}

class StoreMode extends BroadcastState {}

class ProductMode extends BroadcastState {}

class ClientMode extends BroadcastState {}

class BroadcastLoading extends BroadcastState {}

class BroadcastFailed extends BroadcastState {}
