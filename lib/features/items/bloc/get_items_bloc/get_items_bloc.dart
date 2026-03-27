import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:panel_image_uploader/features/items/data/items_remote_data_source.dart';

import '../../../../config/failure.dart';
import '../../models/item.dart';
import '../../models/query.dart';

part 'get_items_event.dart';
part 'get_items_state.dart';

class GetItemsBloc extends Bloc<GetItemsEvent, GetItemsState> {
  ItemsRemoteDataSource ds;
  List<Item?> items = [];
  int offset = 0;
  int limit = 10;
  bool canPag = false;
  GetItemsBloc(this.ds) : super(GetItemsInitial()) {
    on<GetItemsEvent>((event, emit) async {
      if (event is GetItems) {
        emit.call(GetItemsLoading());
        canPag = false;
        emit.call(await _getItems(event));
      }

      if (event is PagItems) {
        if (!canPag) {
          return;
        }

        emit.call(GetItemsPaginating());
        canPag = false;
        emit.call(await _paginate(event));
      }
    });
  }
  Future<GetItemsState> _paginate(PagItems event) async {
    await Future.delayed(const Duration(milliseconds: 400));
    offset += limit;
    final failOrNot = await ds.search(
      Query(offset: offset, limit: limit, search: event.query?.search),
    );
    return failOrNot.fold((l) => GetItemsFailed(l), (r) {
      if (r.length == limit) {
        canPag = true;
      }
      items.addAll(r);
      return GetItemsSuccess(items);
    });
  }

  Future<GetItemsState> _getItems(GetItems event) async {
    offset = 0;
    final failOrNot = await ds.search(Query(limit: limit, offset: 0, search: event.query?.search));
    return failOrNot.fold((l) => GetItemsFailed(l), (r) {
      if (r.length == limit) {
        canPag = true;
      }
      items = r;
      return GetItemsSuccess(items);
    });
  }
}
