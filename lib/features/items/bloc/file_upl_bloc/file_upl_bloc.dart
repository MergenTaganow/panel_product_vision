import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:panel_image_uploader/features/items/data/items_remote_data_source.dart';
import 'package:panel_image_uploader/features/items/models/found_item.dart';

import '../../../../config/failure.dart';
part 'file_upl_event.dart';
part 'file_upl_state.dart';

class FileUplBloc extends Bloc<FileUplEvent, FileUplState> {
  final ItemsRemoteDataSource ds;
  Map<File, double> uploadingFiles = {};
  Map<File, Failure> errorMap = {};
  String? lastType;
  FileUplBloc(this.ds) : super(FileUplInitial()) {
    on<FileUplEvent>((event, emit) async {
      if (event is UploadFiles) {
        if (event.type != lastType) {
          uploadingFiles = {};
          errorMap = {};
          lastType = event.type;
        }
        await _onUploadFileRequested(event, emit);
      }
      if (event is ClearUploading) {
        uploadingFiles = {};
        errorMap = {};
        lastType = null;
        emit.call(FileUplInitial());
      }

      if (event is RemoveFile) {
        uploadingFiles.remove(event.file);
        errorMap.remove(event.file);
        emit(FileUploading(uploadingFiles: uploadingFiles, type: lastType!, errorMap: errorMap));
      }

      if (event is RetryFile) {
        add(RemoveFile(event.file));
        add(UploadFiles(files: [event.file], type: event.type, itemUuid: event.itemUuid));
      }
    });
  }

  Future<void> _onUploadFileRequested(UploadFiles event, Emitter<FileUplState> emit) async {
    for (var i in event.files) {
      uploadingFiles.addAll({i: 0});
    }
    emit(FileUploading(uploadingFiles: uploadingFiles, type: event.type, errorMap: errorMap));
    for (var i in event.files) {
      try {
        await for (final (progress, file) in ds.uploadFile(
          file: i,
          itemUuid: event.itemUuid,
          type: event.type,
        )) {
          uploadingFiles[i] = progress;
          emit(FileUploading(uploadingFiles: uploadingFiles, type: event.type, errorMap: errorMap));

          if (file != null) {
            emit(FileUploadSuccess(file, event.type));
            uploadingFiles.remove(i);
          }
        }
      } catch (e) {
        if (e is DioException) {
          errorMap.addAll({i: Failure(statusCode: e.response?.statusCode, message: e.message)});
        } else {
          errorMap.addAll({i: Failure(message: e.toString())});
        }
        uploadingFiles.remove(i);
        emit(FileUploading(uploadingFiles: uploadingFiles, type: event.type, errorMap: errorMap));
      }
    }
  }
}
