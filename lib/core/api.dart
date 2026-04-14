import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../config/go.dart';
import '../config/injector.dart';
import '../config/routes.dart';
import '../features/auth/bloc/aut_bloc/auth_bloc.dart';
import '../features/auth/data/auth_remote_data_source.dart';
import '../features/auth/data/employee_local_data_source.dart';
import '../features/global/bloc/snackBar_cubit/snack_bar_cubit.dart';

// String baseUrl = 'https://adminpanel.timix.org/api';
String baseUrl = 'https://timar.com.tm/api';

initBaseUrl() {
  if (kDebugMode) {
    // baseUrl = 'http://172.20.14.8:8066/api';
    // baseUrl = 'http://172.20.14.6:8066/api';
    baseUrl = 'https://adminpanel.timix.org/api';
    // baseUrl = 'https://timar.com.tm/api';
  }
  if (kReleaseMode) {
    // baseUrl = 'https://adminpanel.timix.org/api';
    baseUrl = 'https://timar.com.tm/api';
  }
  //   baseUrl = 'http://119.235.112.154:4444/api';
  //  baseUrl = 'http://172.20.14.17:8066/api';
  //  baseUrl = 'http://172.20.17.52:8066/api';
}

class Api {
  final EmployeeLocalDataSource emplDs;

  Api(this.emplDs);

  bool isRefreshing = false;
  Completer<void>? refreshCompleter;
  bool isLoggingOut = false;

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

  Future initApiClient() async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print("request came--${options.path}");
          final token = emplDs.user?.token;

          if (token != null) {
            if ((!options.path.contains('refresh') && !options.path.contains('login')) &&
                _isTokenExpiringSoon(token)) {
              try {
                await _refreshTokenIfNeeded();
              } catch (e) {
                print("onRequest,refresh catch--wil logout");
                _logout();

                return handler.reject(DioException(requestOptions: options, error: e));
              }
            }

            // Add access token for non-authentication requests
            options.headers['Authorization'] = "Bearer ${emplDs.user?.token}";
          }

          if (options.path.contains('login')) {
            isLoggingOut = false;
          }

          return handler.next(options);
        },
        onError: (e, handler) async {
          log('Erroor ocured!');
          //
          print((e.response?.statusCode).toString());
          print(e.response?.data);
          if (e.response?.statusCode == 498) {
            try {
              await _refreshTokenIfNeeded();
              final opts = e.requestOptions;
              opts.headers['Authorization'] = "Bearer ${emplDs.user?.token}";

              final response = await dio.fetch(opts);

              return handler.resolve(response);
            } catch (_) {
              _logout();
              return handler.reject(DioException(requestOptions: e.requestOptions, error: e));
            }
          }
          if (e.response?.statusCode == 401) {
            _logout();

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

  Future<void> _refreshTokenIfNeeded() async {
    if (emplDs.user?.refreshToken == null) {
      throw Exception("No refresh token");
    }
    if (isRefreshing) {
      // Wait until refresh completes
      await refreshCompleter?.future;
      return;
    }

    isRefreshing = true;
    refreshCompleter = Completer();

    try {
      var failOrNot = await sl<AuthRemoteDataSource>().refreshToken();
      failOrNot.fold(
        (l) {
          if (l.statusCode == 403) {
            _logout(message: "youWereBlocked");
          } else if (l.statusCode == 409) {
            _logout(message: "otherDeviceLeggedIn");
          }
          refreshCompleter?.completeError(l);
        },
        (r) {
          refreshCompleter?.complete();
        },
      );
    } catch (e) {
      refreshCompleter?.completeError(e);
      rethrow;
    } finally {
      isRefreshing = false;
    }
  }

  bool _isTokenExpiringSoon(String token) {
    try {
      final expiryDate = JwtDecoder.getExpirationDate(token);
      // final exp = decoded['exp']; // seconds since epoch
      //
      //  = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      print("difference ${expiryDate.difference(now)}");
      // check if less than 5 minutes left
      return expiryDate.difference(now) <= const Duration(minutes: 1);
    } catch (e) {
      return true; // if decoding fails → treat as expired
    }
  }

  void _logout({String? message}) {
    if (isLoggingOut) return;

    isLoggingOut = true;

    sl<AuthBloc>().add(LogoutEvent());
    Go.too(Routes.login);

    if (message != null) {
      sl<SnackBarCubit>().showSnackBar(message, true);
    }
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
