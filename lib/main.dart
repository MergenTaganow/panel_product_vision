import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'config/injector.dart';
import 'core/api.dart';
import 'features/auth/bloc/aut_bloc/auth_bloc.dart';
import 'features/global/bloc/boolean_filter_cubit/boolean_filter_cubit.dart';
import 'features/global/bloc/date_time_check_cubit/date_time_check_cubit.dart';
import 'features/global/bloc/key_filter_cubit/key_filter_cubit.dart';
import 'features/global/bloc/sort_cubit/sort_cubit.dart';
import 'features/items/bloc/file_delete_cubit/file_delete_cubit.dart';
import 'features/items/bloc/file_upl_bloc/file_upl_bloc.dart';
import 'features/items/bloc/get_items_bloc/get_items_bloc.dart';
import 'features/items/bloc/item_uuid/item_uuid_cubit.dart';
import 'features/items/bloc/tab/tab_cubit.dart';
import 'features/items/bloc/update_image_cubit/update_image_cubit.dart';
import 'features/items/pages/camera_page.dart';
import 'features/scan/bloc/barcode_data_fetcher/barcode_data_fetcher_cubit.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await getVersion();
  cameras = await availableCameras();
  initBaseUrl();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()..add(GetLocalUser())),
        BlocProvider<BooleanFilterCubit>(create: (context) => sl<BooleanFilterCubit>()),
        // BlocProvider(create: (context) => sl<BroadcastCubit>()..init(), lazy: true),
        BlocProvider<BarcodeDataFetcherCubit>(create: (context) => sl<BarcodeDataFetcherCubit>()),
        BlocProvider(create: (context) => sl<DateTimeCheckCubit>(), lazy: false),
        BlocProvider(create: (context) => sl<KeyFilterCubit>()),
        BlocProvider(create: (context) => sl<SortCubit>()),
        BlocProvider(create: (context) => sl<GetItemsBloc>()),
        BlocProvider(create: (context) => sl<ItemUuidCubit>()),
        BlocProvider(create: (context) => sl<ItemByUuidForSheet>()),
        BlocProvider(create: (context) => sl<TabCubit>()),
        BlocProvider(create: (context) => sl<FileUplBloc>()),
        BlocProvider(create: (context) => sl<FileDeleteCubit>()),
        BlocProvider(create: (context) => sl<UpdateImageCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

getVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  version = packageInfo.version;
}
