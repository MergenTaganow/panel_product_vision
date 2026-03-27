part of 'update_image_cubit.dart';

@immutable
sealed class UpdateImageState {}

final class UpdateImageInitial extends UpdateImageState {}

final class UpdateImageLoading extends UpdateImageState {}

final class UpdateImageFailed extends UpdateImageState {
  final Failure failure;
  UpdateImageFailed(this.failure);
}

final class MarketAsMainImage extends UpdateImageState {
  final String itemUuid;
  final String imageUuid;
  final String type;
  MarketAsMainImage({required this.itemUuid, required this.imageUuid, required this.type});
}
