part of 'file_upl_bloc.dart';

@immutable
sealed class FileUplEvent {}

class UploadFiles extends FileUplEvent {
  final List<File> files;
  final String type;
  final String itemUuid;

  UploadFiles({required this.files, required this.type, required this.itemUuid});
}

class RemoveFile extends FileUplEvent {
  final File file;
  RemoveFile(this.file);
}

class RetryFile extends FileUplEvent {
  final File file;
  final String type;
  final String itemUuid;
  RetryFile({required this.file, required this.type, required this.itemUuid});
}

class ClearUploading extends FileUplEvent {}
