import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../auth/data/auth_remote_data_source.dart';
import 'barcode_data_types.dart';

part 'barcode_data_fetcher_state.dart';

class BarcodeDataFetcherCubit extends Cubit<BarcodeDataFetcherState> {
  AuthRemoteDataSource ds;
  BarcodeDataFetcherCubit(this.ds) : super(BarcodeDataFetcherInitial());

  fetchBarcodeData({required String barcodeData}) async {
    emit.call(BarcodeDataFetcherLoading());
    var failOrNot = await ds.fetchBarcodeData(barcodeData: barcodeData);
    failOrNot.fold((l) => emit.call(BarcodeDataFetcherFailed()), (r) {});
  }
}
