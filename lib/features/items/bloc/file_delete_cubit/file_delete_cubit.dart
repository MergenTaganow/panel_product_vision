import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:panel_image_uploader/config/failure.dart';
import 'package:panel_image_uploader/features/items/data/items_remote_data_source.dart';

part 'file_delete_state.dart';

class FileDeleteCubit extends Cubit<FileDeleteState> {
  ItemsRemoteDataSource ds;
  FileDeleteCubit(this.ds) : super(FileDeleteInitial());

  deleteImage({required String itemUuid, required String imageUuid}) async {
    emit(FileDeleteLoading());
    var failOrNot = await ds.deleteImage(itemUuid: itemUuid, imageUuid: imageUuid);

    failOrNot.fold((l) => emit(FileDeleteFailed(l)), (r) => emit(FileDeleteSuccess()));
  }
}
