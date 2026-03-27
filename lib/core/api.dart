import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/go.dart';
import '../config/injector.dart';
import '../config/routes.dart';
import '../features/auth/bloc/aut_bloc/auth_bloc.dart';
import '../features/auth/data/employee_local_data_source.dart';

String baseUrl = 'https://adminpanel.timix.org/api';

initBaseUrl() {
  if (kDebugMode) {
    // baseUrl = 'http://172.20.14.8:8066/api';
    // baseUrl = 'http://172.20.14.6:8066/api';
    baseUrl = 'https://adminpanel.timix.org/api';
  }
  if (kReleaseMode) {
    baseUrl = 'https://adminpanel.timix.org/api';
  }
  //   baseUrl = 'http://119.235.112.154:4444/api';
  //  baseUrl = 'http://172.20.14.17:8066/api';
  //  baseUrl = 'http://172.20.17.52:8066/api';
}

class Api {
  final EmployeeLocalDataSource emplDs;

  Api(this.emplDs);

  Dio dio = Dio(
    BaseOptions(
      receiveTimeout: const Duration(minutes: 5),
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(minutes: 5),
      baseUrl: baseUrl,
    ),
  );

  void setBaseUrl(String url) {
    dio.options.baseUrl = url;
    baseUrl = url;
  }

  List<RefreshError> waitingList = [];
  List<Request> requestList = [];

  Future initApiClient() async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print(options.path);
          requestList.add(Request(options: options, handl: handler));

          // Add access token for non-authentication requests
          if (emplDs.user?.token != null) {
            options.headers['Authorization'] = "Bearer ${emplDs.user?.token}";
          }

          return handler.next(options);
        },
        onError: (e, handler) async {
          log('Erroor ocured!');
          //
          print((e.response?.statusCode).toString());
          print(e.response?.data);
          if (e.response?.statusCode == 401 || e.response?.statusCode == 498) {
            sl<AuthBloc>().add(LogoutEvent());
            Future.delayed(const Duration(seconds: 3)).then((value) => Go.too(Routes.login));

            return handler.reject(DioException(requestOptions: e.requestOptions, error: e));
          }
          // Check if the error is network-related (offline)
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.connectionError) {
            log('Network error: User is likely offline.');
            // Optionally show a message to the user or handle it gracefully
            // Avoid logging out the user for network issues
            return handler.reject(e);
          } else {
            return handler.reject(e);
          }
        },
      ),
    );
  }
}

class RefreshError {
  DioException err;
  ErrorInterceptorHandler handl;
  RefreshError({required this.err, required this.handl});
}

class Request {
  RequestOptions options;
  RequestInterceptorHandler handl;
  Request({required this.options, required this.handl});
}
