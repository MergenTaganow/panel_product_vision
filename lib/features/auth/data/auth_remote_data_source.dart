import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../../config/failure.dart';
import '../../../config/ios_device_names.dart';
import '../../../core/api.dart';
import '../../../my_app.dart';
import '../../items/models/item.dart';
import '../../scan/bloc/barcode_data_fetcher/barcode_data_types.dart';
import '../models/user.dart';
import 'employee_local_data_source.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
    bool rememberMe = false,
    double? latitude,
    double? longitude,
  });

  Future<Either<Failure, BarcodeDataTypes>> fetchBarcodeData({required String barcodeData});
  Future<Either<Failure, DateTime?>> getServerDate();
  Future<Either<Failure, Map<String, dynamic>>> getServerVersion();
  Future<Either<Failure, User>> refreshToken();
}

class AuthRemoteDataImpl extends AuthRemoteDataSource {
  final Api api;
  final EmployeeLocalDataSource local;
  AuthRemoteDataImpl(this.api, this.local);

  @override
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
    bool rememberMe = false,
    double? latitude,
    double? longitude,
  }) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String? header;
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        header = '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

        header = iosDeviceNames[iosInfo.utsname.machine];
      }
      var data = {
        'userName': username,
        'password': password,
        'program': 'PANEL_PRODUCT_VISION',
        'version': version,
        'deviceInfo': header,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };
      print('url is-- ${api.dio.options.baseUrl}--$data');
      var response = await api.dio.post('/admin/v1/employees/login', data: data);
      if (response.statusCode == 200) {
        final userMap =
            response.data['accesses']..addAll({
              "token": response.data['token'],
              "refreshToken": response.data['refreshToken'],
              "fullName": response.data['fullName'],
              'name': response.data['fullName'],
              'username': username,
              'uuid': response.data['uuid'],
            });
        if (!userMap.containsKey("item")) userMap['item'] = [];

        User? user = User.fromJson(userMap);
        // set token to dio header
        final token = user.token;
        if (token != null) {
          api.dio.options.headers['Authorization'] = "Bearer $token";
        }
        // save user to local data source
        local.saveRememberMe = rememberMe;
        local.saveUser(u: user);
        return Right(user);
      } else {
        return Left(Failure(statusCode: response.statusCode, message: response.data.toString()));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(Failure(statusCode: e.response?.statusCode, message: e.message));
      }
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, BarcodeDataTypes>> fetchBarcodeData({required String barcodeData}) async {
    try {
      var queryParams = {
        'language':
            MyAppState.appLocale?.languageCode == 'tr'
                ? 'tm'
                : MyAppState.appLocale?.languageCode ?? 'tm',
        'program': 'PANEL_PRODUCT_VISION',
        'page': 'search',
      };
      final response = await api.dio.get(
        '/qrEmployee/v1/items/barcode/$barcodeData',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        Item item = Item.fromMap(response.data);
        BarcodeDataTypes barcodeDataType = BarcodeDataTypes(
          type: BroadcastResponseModelTypes.item,
          item: item,
        );
        return Right(barcodeDataType);
      } else {
        return const Left(Failure());
      }
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, DateTime?>> getServerDate() async {
    try {
      final response = await api.dio.get('/v1/serverTime');
      if (response.statusCode == 200) {
        var date = DateTime.tryParse((response.data['datetime']));
        return Right(date);
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
  Future<Either<Failure, Map<String, dynamic>>> getServerVersion() async {
    try {
      final response = await api.dio.get('/app/PANEL_PRODUCT_VISION/lastVersion');
      if (response.statusCode == 200) {
        return Right(response.data);
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
  Future<Either<Failure, User>> refreshToken() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String? header;
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        header = '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

        header = iosDeviceNames[iosInfo.utsname.machine];
      }
      var data = {
        'program': 'PANEL_PRODUCT_VISION',
        "refreshToken": local.user?.refreshToken ?? '',
        'version': version,
        'deviceInfo': header,
      };
      var response = await api.dio.post('/admin/v1/employees/refresh', data: data);

      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        final userMap =
            response.data['accesses']..addAll({
              "token": response.data['token'],
              "refreshToken": response.data['refreshToken'],
              "fullName": response.data['fullName'],
              'name': response.data['fullName'],
              'uuid': response.data['uuid'],
            });
        if (!userMap.containsKey("item")) userMap['item'] = [];

        User? user = User.fromJson(userMap);
        // set token to dio header
        final token = user.token;
        if (token != null) {
          api.dio.options.headers['Authorization'] = "Bearer $token";
        }
        // save user to local data source
        local.saveUser(u: user);
        return Right(user);
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
