import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panel_image_uploader/features/items/data/items_remote_data_source.dart';

import '../../../../config/failure.dart';
import '../../../../config/injector.dart';
import '../../models/item.dart';

part 'item_uuid_state.dart';

class ItemUuidCubit extends Cubit<ItemUuidState> {
  ItemsRemoteDataSource service;
  ItemUuidCubit(this.service) : super(ItemUuidInitial());

  getItem({
    required String uuid,
    required String page,
    required bool fetchedFromBarcode,
    bool addToHistory = true,
  }) async {
    emit.call(ItemUuidLoading());
    final failOrNot = await service.getItem(uuid: uuid, page: page);
    return failOrNot.fold((l) => emit.call(ItemUuidFailed(l)), (r) {
      emit.call(ItemUuidSuccess(r, fetchedFromBarcode));
      if (addToHistory) {
        // sl<ItemHistoryCubit>().addItemToList(r);
      }
    });
  }

  refresh({required String uuid}) async {
    final failOrNot = await service.getItem(uuid: uuid, page: 'search');
    return failOrNot.fold((l) => emit.call(ItemUuidFailed(l)), (r) {
      emit.call(ItemUuidSuccess(r, false));
    });
  }

  setItem({Item? item, required bool fetchedFromBarcode}) {
    emit.call(ItemUuidSuccess(item, fetchedFromBarcode));
    // sl<ItemHistoryCubit>().addItemToList(item);
  }
}

class ItemByUuidForSheet extends ItemUuidCubit {
  ItemByUuidForSheet(super.service);
}
