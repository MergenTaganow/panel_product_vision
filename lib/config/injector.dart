import 'package:get_it/get_it.dart';
import 'package:panel_image_uploader/features/items/bloc/get_items_bloc/get_items_bloc.dart';
import 'package:panel_image_uploader/features/items/data/items_remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api.dart';
import '../features/android_update/bloc/UpdateCubit/update_cubit.dart';
import '../features/auth/bloc/aut_bloc/auth_bloc.dart';
import '../features/auth/data/auth_remote_data_source.dart';
import '../features/auth/data/employee_local_data_source.dart';
import '../features/global/bloc/boolean_filter_cubit/boolean_filter_cubit.dart';
import '../features/global/bloc/date_time_check_cubit/date_time_check_cubit.dart';
import '../features/global/bloc/key_filter_cubit/key_filter_cubit.dart';
import '../features/global/bloc/sort_cubit/sort_cubit.dart';
import '../features/items/bloc/file_delete_cubit/file_delete_cubit.dart';
import '../features/items/bloc/file_upl_bloc/file_upl_bloc.dart';
import '../features/items/bloc/item_uuid/item_uuid_cubit.dart';
import '../features/items/bloc/tab/tab_cubit.dart';
import '../features/items/bloc/update_image_cubit/update_image_cubit.dart';
import '../features/scan/bloc/barcode_data_fetcher/barcode_data_fetcher_cubit.dart';

GetIt sl = GetIt.instance;
Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton<Api>(() => Api(sl())..initApiClient());
  sl.registerLazySingleton<EmployeeLocalDataSource>(() => EmployeeLocalDataSourceImpl(pref: sl()));

  //auth
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl(), sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataImpl(sl(), sl()));
  // sl.registerLazySingleton<DateTimeCheckCubit>(() => DateTimeCheckCubit(sl()));

  //glovbal
  sl.registerLazySingleton<BooleanFilterCubit>(() => BooleanFilterCubit());
  sl.registerLazySingleton<DateTimeCheckCubit>(() => DateTimeCheckCubit(sl()));
  sl.registerLazySingleton<KeyFilterCubit>(() => KeyFilterCubit());
  sl.registerLazySingleton<SortCubit>(() => SortCubit());
  sl.registerLazySingleton<BarcodeDataFetcherCubit>(() => BarcodeDataFetcherCubit(sl()));
  sl.registerLazySingleton<UpdateCubit>(() => UpdateCubit(sl()));

  //items
  sl.registerLazySingleton<ItemsRemoteDataSource>(() => ItemsRemoteDataImpl(sl(), sl()));
  sl.registerLazySingleton<GetItemsBloc>(() => GetItemsBloc(sl()));
  sl.registerLazySingleton<ItemUuidCubit>(() => ItemUuidCubit(sl()));
  sl.registerLazySingleton<ItemByUuidForSheet>(() => ItemByUuidForSheet(sl()));
  sl.registerLazySingleton<TabCubit>(() => TabCubit());
  sl.registerLazySingleton<FileUplBloc>(() => FileUplBloc(sl()));
  sl.registerLazySingleton<FileDeleteCubit>(() => FileDeleteCubit(sl()));
  sl.registerLazySingleton<UpdateImageCubit>(() => UpdateImageCubit(sl()));
}
