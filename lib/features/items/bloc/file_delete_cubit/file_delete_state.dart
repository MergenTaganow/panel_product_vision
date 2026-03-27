part of 'file_delete_cubit.dart';

@immutable
sealed class FileDeleteState {}

final class FileDeleteInitial extends FileDeleteState {}

final class FileDeleteLoading extends FileDeleteState {}

final class FileDeleteFailed extends FileDeleteState {
  final Failure failure;
  FileDeleteFailed(this.failure);
}

final class FileDeleteSuccess extends FileDeleteState {}
