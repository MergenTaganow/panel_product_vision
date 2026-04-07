import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../../config/failure.dart';
import '../../../core/api.dart';
import '../../scan/bloc/barcode_data_fetcher/barcode_data_types.dart';
import '../models/user.dart';
import 'employee_local_data_source.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
    bool rememberMe = false,
  });

  Future<Either<Failure, BarcodeDataTypes>> fetchBarcodeData({required String barcodeData});
  Future<Either<Failure, DateTime?>> getServerDate();
  Future<Either<Failure, Map<String, dynamic>>> getServerVersion();
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
  }) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      Map<String, dynamic>? header;
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        log('${androidInfo.manufacturer} ${androidInfo.model}');
        header = {
          'deviceName': '${androidInfo.manufacturer} ${androidInfo.model}',
          'Sec-CH-UA-Platform': Platform.isAndroid ? 'Android' : 'Ios',
          'Sec-CH-UA-Platform-Version': androidInfo.version,
          'Sec-CH-UA-Model': '${androidInfo.manufacturer} ${androidInfo.model}',
          'Sec-CH-UA-Mobile': true,
          'Content-Type': 'application/json',
          'Accept': "application/json",
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        log(iosInfo.utsname.machine); // Log the machine name, e.g., 'iPhone13,2'

        header = {
          'deviceName': iosInfo.utsname.machine,
          'Sec-CH-UA-Platform': Platform.isAndroid ? 'Android' : 'iOS',
          'Sec-CH-UA-Platform-Version': iosInfo.systemVersion,
          'Sec-CH-UA-Model': iosInfo.utsname.machine,
          'Sec-CH-UA-Mobile': true,
          'Content-Type': 'application/json',
          'Accept': "application/json",
        };
      }
      var data = {'userName': username, 'password': password, 'program': 'panelImageUploader'};
      print('url is-- ${api.dio.options.baseUrl}');
      var response = await api.dio.post(
        '/admin/v1/employees/login',
        data: data,
        options: Options(headers: header),
      );
      if (response.statusCode == 200) {
        final userMap =
            response.data['accesses']..addAll({
              "token": response.data['token'],
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
      final response = await api.dio.get('/admin/v1/alManufactory/orders/qr/$barcodeData');

      if (response.statusCode == 200) {
        return Right(BarcodeDataTypes(type: BroadcastResponseModelTypes.mbProduct));
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
}
