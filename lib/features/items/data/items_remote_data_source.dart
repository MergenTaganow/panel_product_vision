import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:panel_image_uploader/features/items/models/found_item.dart';
import '../../../config/failure.dart';
import '../../../config/injector.dart';
import '../../../core/api.dart';
import '../../auth/data/employee_local_data_source.dart';
import '../../global/bloc/sort_cubit/sort_cubit.dart';
import '../models/item.dart';
import '../models/query.dart';

abstract class ItemsRemoteDataSource {
  Future<Either<Failure, List<Item?>>> search(Query? query);
  Future<Either<Failure, Item>> getItem({required String uuid, required String page});
  Stream<(double, Images?)> uploadFile({
    required String itemUuid,
    required String type,
    required File file,
  });
  Future<Either<Failure, Success>> deleteImage({
    required String itemUuid,
    required String imageUuid,
  });
  Future<Either<Failure, Success>> updateItemImage({
    required String itemUuid,
    required String imageUuid,
    required Map<String, dynamic> data,
  });
}

class ItemsRemoteDataImpl extends ItemsRemoteDataSource {
  final Api api;
  final EmployeeLocalDataSource local;
  ItemsRemoteDataImpl(this.api, this.local);

  @override
  Future<Either<Failure, List<Item?>>> search(Query? query) async {
    try {
      var queryParam = query?.toMap().map((key, value) {
        // Ensure all values are converted to a string
        if (value is! String && value is! List<String>) {
          return MapEntry(key, value.toString());
        }
        return MapEntry(key, value);
      });

      ///will if items will searched as sorted
      var selectedSort = sl<SortCubit>().sortMap;
      if (selectedSort[SortCubit.itemSort] != null) {
        queryParam?.addAll({'sortBy': selectedSort[SortCubit.itemSort]?.sortBy});
        queryParam?.addAll({'sortAs': selectedSort[SortCubit.itemSort]?.sortAs});
      }

      ///will if items will searched with groups filtered
      // var selectedGroups =
      //     sl<GroupSelectionCubit>().selectedMap[GroupSelectionCubit.itemsGroups]?.lastGroups ?? [];
      // if (selectedGroups.isNotEmpty) {
      //   var lastGroupUuids = selectedGroups.map((e) => e?.uuid).toList();
      //   queryParam?.addAll({'lastGroupUuids[]': lastGroupUuids});
      // }

      ///will if items will searched with specodes filtered
      // var selectedSpecodes =
      // sl<SpecodesSelectingCubit>().selectedSpecodesMap[SpecodesSelectingCubit.itemSpecodes];
      // if (selectedSpecodes?.isNotEmpty ?? false) {
      //   queryParam?.addAll({'specodes[]': selectedSpecodes});
      // }

      ///will if items will searched with paretto filtered
      // var selectedParettos =
      // sl<ParettoSelectingCubit>().selectedParettosMap[ParettoSelectingCubit.itemParettos];
      // if (selectedParettos?.isNotEmpty ?? false) {
      //   queryParam?.addAll({'paretto[]': selectedParettos});
      // }
      //
      // var filter = sl<ItemsFilterCubit>().filteredMap[ItemsFilterCubit.itemsPage];
      // if (filter?.selectedIsWeekly != null) {
      //   queryParam?.addAll({'isWeeklyTrend': filter?.selectedIsWeekly.toString()});
      // }
      // if (filter?.selectedIsMonthly != null) {
      //   queryParam?.addAll({'isMonthlyTrend': filter?.selectedIsMonthly.toString()});
      // }
      // if (filter?.selectedIsNew != null) {
      //   queryParam?.addAll({'isNew': filter?.selectedIsNew.toString()});
      // }
      final response = await api.dio.get('/admin/v1/items', queryParameters: queryParam);
      if (response.statusCode == 200) {
        List<Item>? listItems = ((response.data) as List).map((e) => Item.fromMap(e)).toList();
        return Right(listItems);
      } else {
        return Left(Failure(statusCode: response.statusCode, message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(Failure(statusCode: e.response?.statusCode, message: e.message));
      }
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, Item>> getItem({required String uuid, required String page}) async {
    try {
      final response = await api.dio.get('/admin/v1/items/$uuid');

      if (response.statusCode == 200) {
        var item = Item.fromMap((response.data));
        return Right(item);
      } else {
        return Left(Failure(statusCode: response.statusCode, message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(Failure(statusCode: e.response?.statusCode, message: e.message));
      }
      return const Left(Failure());
    }
  }

  @override
  Stream<(double, Images?)> uploadFile({
    required String itemUuid,
    required String type,
    required File file,
  }) {
    final controller = StreamController<(double, Images?)>();

    () async {
      try {
        final fileName = file.path.split('/').last;

        final formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            headers: {
              'filepath': [file.path],
            },
          ),
          'type': type,
        });

        final response = await api.dio.post(
          '/admin/v1/items/$itemUuid/images',
          data: formData,
          onSendProgress: (sent, total) {
            if (total > 0 && !controller.isClosed) {
              controller.add((sent / total, null)); // ✅ progress update
            }
          },
        );
        print(response.data);
        final uploaded = Images.fromJson(response.data['data']);
        print(uploaded.mediumImg);

        // if (file == null) {
        //   if (!controller.isClosed) {
        //     controller.addError({"message": "smthWentWrong"});
        //   }
        //   return;
        // }

        // ✅ ALWAYS emit success BEFORE closing
        if (!controller.isClosed) {
          controller.add((1.0, uploaded));
        }

        // ✅ Give event loop one tick to deliver last value
        await Future.delayed(Duration.zero);
      } catch (e) {
        if (!controller.isClosed) {
          controller.addError(e);
        }
      } finally {
        if (!controller.isClosed) {
          await controller.close();
        }
      }
    }();

    return controller.stream;
  }

  @override
  Future<Either<Failure, Success>> deleteImage({
    required String itemUuid,
    required String imageUuid,
  }) async {
    try {
      final response = await api.dio.delete('/admin/v1/items/$itemUuid/images/$imageUuid');

      if (response.statusCode == 200) {
        return Right(Success());
      } else {
        return Left(Failure(statusCode: response.statusCode, message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(Failure(statusCode: e.response?.statusCode, message: e.message));
      }
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, Success>> updateItemImage({
    required String itemUuid,
    required String imageUuid,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await api.dio.put('/admin/v1/items/$itemUuid/images/$imageUuid', data: data);

      if (response.statusCode == 200) {
        return Right(Success());
      } else {
        return Left(Failure(statusCode: response.statusCode, message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(Failure(statusCode: e.response?.statusCode, message: e.message));
      }
      return const Left(Failure());
    }
  }
}
