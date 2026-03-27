import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:panel_image_uploader/config/failure.dart';
import 'package:panel_image_uploader/features/items/data/items_remote_data_source.dart';

part 'update_image_state.dart';

class UpdateImageCubit extends Cubit<UpdateImageState> {
  final ItemsRemoteDataSource ds;
  UpdateImageCubit(this.ds) : super(UpdateImageInitial());

  makeAsMain({required String itemUuid, required String imageUuid, required String type}) async {
    emit(UpdateImageLoading());
    final failOrNot = await ds.updateItemImage(
      itemUuid: itemUuid,
      imageUuid: imageUuid,
      data: {"mainImage": true, "type": type},
    );

    failOrNot.fold(
      (l) => emit(UpdateImageFailed(l)),
      (r) => emit(MarketAsMainImage(imageUuid: imageUuid, itemUuid: itemUuid, type: type)),
    );
  }
}
