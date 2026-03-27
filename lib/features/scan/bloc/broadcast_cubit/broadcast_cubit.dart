import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_broadcasts/flutter_broadcasts.dart';

part 'broadcast_state.dart';

class BroadcastCubit extends Cubit<BroadcastState> {
  // StoreQrBloc _storeQrBloc;
  // ItemBloc _itemBloc;
  // ClientBloc _clientBloc;
  // BroadcastReceiver receiver = BroadcastReceiver(
  //   names: <String>[
  //     "com.scanner.broadcast", // hendheld
  //     // "com.uupy.flutter_pda_scanner/plugin",
  //     // "com.android.server.scannerservice.broadcast",
  //     // "com.android.server.scannerservice.shinow",
  //     // "android.intent.action.SCANRESULT",
  //     "android.intent.ACTION_DECODE_DATA", // urova
  //     // "scan.rcv.message",
  //     // "com.ehsy.warehouse.action.BARCODE_DATA",
  //     "com.dukanda",
  //     "com.honeywell.decode.intent.action.EDIT_DATA", // honeyweel
  //   ],
  // );
  BroadcastCubit(/* StoreQrBloc storeQrBloc, ItemBloc itemBloc, ClientBloc clientBloc */)
      : /*  _clientBloc = clientBloc,
        _itemBloc = itemBloc,
        _storeQrBloc = storeQrBloc, */
        super(BroadcastInitial());
  // init() async {
  //   if (Platform.isAndroid) {
  //     await receiver.start();
  //   }
  // }
  //
  // getStoreBroadCast() async* {
  //   emit.call(BroadcastLoading());
  //   receiver.messages.listen((event) {});
  // }
}
