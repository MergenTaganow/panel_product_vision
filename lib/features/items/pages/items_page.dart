import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:ota_update/ota_update.dart';
import '../../../config/colors.dart';
import '../../../config/go.dart';
import '../../../config/helpers.dart';
import '../../../config/routes.dart';
import '../../../core/api.dart';
import '../../android_update/bloc/UpdateCubit/update_cubit.dart';
import '../../auth/widgets/change_lang.dart';
import '../../global/bloc/date_time_check_cubit/date_time_check_cubit.dart';
import '../../global/bloc/sort_cubit/sort_cubit.dart';
import '../bloc/get_items_bloc/get_items_bloc.dart';
import '../models/item.dart';
import '../models/item_interesting_type.dart';
import '../models/query.dart';
import '../widgets/found_item_card.dart';
import '../widgets/search_box_customers.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  TextEditingController textController = TextEditingController();
  DateTime lastBarcodeFetchedDate = DateTime.now();
  List<Item?> items = [];
  int? selectedSortIndex;
  bool newYearMode = false;

  String status = '';
  String percentage = '0';

  @override
  void initState() {
    context.read<UpdateCubit>().checkUpdate();
    context.read<DateTimeCheckCubit>().checkDateTime();
    // context.read<BroadcastCubit>().receiver.messages.listen((event) {
    //   var data =
    //       event.data?['barcode_string'] ?? event.data?['barcodeStringData'] ?? event.data?['data'];
    //   try {
    //     int differenceInSeconds = lastBarcodeFetchedDate.difference(DateTime.now()).inSeconds.abs();
    //     if (data != null && differenceInSeconds >= 1) {
    //       lastBarcodeFetchedDate = DateTime.now();
    //       context.read<BarcodeDataFetcherCubit>().fetchBarcodeData(
    //         barcodeData: data,
    //         page: ItemInterestingType.byScan,
    //       );
    //     }
    //   } catch (e) {
    //     log(e.toString());
    //   }
    // });
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        context.read<GetItemsBloc>().add(
          PagItems(query: Query(search: searchController.text.trim())),
        );
      }
    });
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    var sorts = [
      Sort(text: lg.sortAZ, sortBy: 'byName'),
      Sort(text: lg.sortNewProducts, sortBy: 'newest'),
      Sort(text: lg.sortMostSold, sortBy: 'paretto'),
    ];
    // int selectedParettoLength =
    //     context
    //         .watch<ParettoSelectingCubit>()
    //         .selectedParettosMap[ParettoSelectingCubit.itemParettos]
    //         ?.length ??
    //     0;
    // int selectedGroupsLength =
    //     context
    //         .watch<GroupSelectionCubit>()
    //         .selectedMap[GroupSelectionCubit.itemsGroups]
    //         ?.lastGroups
    //         .length ??
    //     0;
    // int selectedSpecodesLength =
    //     context
    //         .watch<SpecodesSelectingCubit>()
    //         .selectedSpecodesMap[SpecodesSelectingCubit.itemSpecodes]
    //         ?.length ??
    //     0;
    // ItemsFilterSuccess state = (context.watch<ItemsFilterCubit>().state as ItemsFilterSuccess);
    // var filter = state.filteredMap[ItemsFilterCubit.itemsPage];
    // bool? isNewValue = filter?.selectedIsNew;
    // bool? isWeekValue = filter?.selectedIsWeekly;
    // bool? isMonthValue = filter?.selectedIsMonthly;
    var count =
        // (selectedGroupsLength == 0 ? 0 : 1) +
        // (selectedSpecodesLength == 0 ? 0 : 1) +
        // (selectedParettoLength == 0 ? 0 : 1) +
        // (isNewValue == null ? 0 : 1) +
        // (isWeekValue == null ? 0 : 1) +
        // (isMonthValue == null ? 0 : 1)
        0;
    return BlocListener<UpdateCubit, UpdateState>(
      listener: (context, state) {
        if (state is NeedUpdate) {
          updateSheet();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(lg.items), actions: const [EditLang()]),
        // floatingActionButton: Row(
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     // BlocBuilder<ItemHistoryCubit, ItemHistoryState>(
        //     //   builder: (context, state) {
        //     //     if (state is ItemHistorySuccess && state.items.isNotEmpty) {
        //     //       return FloatingActionButton(
        //     //         onPressed: () {
        //     //           Go.to(Routes.itemHistoryPage);
        //     //         },
        //     //         backgroundColor: const Color(0xFFFFF0EB),
        //     //         child: Svvg.asset('history'),
        //     //       );
        //     //     }
        //     //     return Container();
        //     //   },
        //     // ),
        //     Box(w: 10),
        //     Stack(
        //       clipBehavior: Clip.none,
        //       alignment: Alignment.topRight,
        //       children: [
        //         FloatingActionButton(
        //           onPressed: () {
        //             // Go.to(
        //             //   Routes.itemsFilterPage,
        //             //   argument: {
        //             //     'onFilter': () {
        //             //       context.read<GetItemsBloc>().add(
        //             //         GetItems(query: Query(search: searchController.text.trim())),
        //             //       );
        //             //     },
        //             //   },
        //             // );
        //           },
        //           backgroundColor: Col.primary,
        //           child: Svvg.asset('whiteFilter'),
        //         ),
        //         if (newYearMode)
        //           Positioned(
        //             top: -35,
        //             right: -8,
        //             child: Image.asset('assets/images/new_year_cap.png'),
        //           ),
        //         if (count > 0)
        //           Positioned(
        //             right: 3,
        //             top: 3,
        //             child: Container(
        //               height: 12,
        //               width: 12,
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(100),
        //                 color: Colors.green,
        //               ),
        //             ),
        //           ),
        //       ],
        //     ),
        //   ],
        // ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Padd(
              hor: 16,
              child: Column(
                children: [
                  SearchBoxScanSort(
                    controller: searchController,
                    type: SearchType.items,
                    onSort: () {
                      radioSelectingSort(
                        context: context,
                        sorts: sorts,
                        key: SortCubit.itemSort,
                        onTap: () {
                          Navigator.pop(context);
                          context.read<GetItemsBloc>().add(
                            GetItems(query: Query(search: searchController.text.trim())),
                          );
                        },
                      );
                    },
                    onScan: () {
                      Go.to(Routes.scanPage);
                    },
                    onSubmitted: (str) {
                      context.read<GetItemsBloc>().add(GetItems(query: Query(search: str)));
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<GetItemsBloc, GetItemsState>(
                builder: (context, state) {
                  if (state is GetItemsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is GetItemsSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      setState(() {
                        items = state.items;
                      });
                    });
                  }
                  if (items.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: Column(
                        children: [
                          Svvg.asset('_search', color: Col.gray50.withOpacity(0.1), w: 140, h: 140),
                          Box(h: 10),
                          Text(lg.itemSearch, style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      context.read<GetItemsBloc>().add(
                        GetItems(query: Query(search: searchController.text)),
                      );
                    },
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        return ItemCard(
                          item: items[index],
                          pageType: ItemInterestingType.byScan,
                          openSheet: false,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return (index == items.length - 1)
                            ? const CircularProgressIndicator()
                            : Container();
                      },
                      itemCount: items.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> updateSheet() async {
    // openInstallPermissionSettings();
    var state = context.read<UpdateCubit>().state;
    var newVersion = state is NeedUpdate ? state.lastVersion : null;
    if (newVersion == null) return;
    AppLocalizations lg = AppLocalizations.of(context)!;
    return showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      context: context,
      builder: (context) {
        DateFormat dateFormat = DateFormat('dd MMM yyyy');
        return StatefulBuilder(
          builder: (context, setState2) {
            return Padd(
              hor: 20,
              ver: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    lg.newVersionAvailable,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Box(h: 10),
                  Text(
                    lg.newVersionDescr,
                    style: const TextStyle(fontSize: 13, color: Color(0xFFA1A1A1)),
                  ),
                  Box(h: 10),
                  Row(
                    children: [
                      Image.asset('assets/images/icon.png', height: 50),
                      Box(w: 10),
                      Text(
                        'Panel Product Vision',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Col.primary,
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    shape: const RoundedRectangleBorder(side: BorderSide.none),
                    collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
                    tilePadding: const EdgeInsets.symmetric(vertical: 10),
                    textColor: Colors.black,
                    iconColor: Colors.black,
                    title: Text(
                      lg.news,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '${lg.uploadedDate} ${dateFormat.format(newVersion.createdAt ?? DateTime.now())}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFFA1A1A1)),
                    ),
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      if (newVersion.updateInfo?.isNotEmpty ?? false)
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            newVersion!.updateInfo!,
                            style: const TextStyle(fontSize: 13),
                            textAlign: TextAlign.left,
                          ),
                        ),
                    ],
                  ),
                  Box(h: 15),
                  status == 'DOWNLOADING'
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            lg.downloading,
                            style: const TextStyle(fontSize: 13, color: Color(0xFFA1A1A1)),
                          ),
                          Box(h: 2),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
                              overlayShape: SliderComponentShape.noOverlay,
                            ),
                            child: Slider(
                              value: double.parse(percentage) / 100,
                              inactiveColor: const Color(0xFFCEEAD6),
                              activeColor: const Color(0xFF39816B),
                              onChanged: (r) {
                                // if (r == .95) {
                                //   Navigator.of(context,
                                //           rootNavigator: true)
                                //       .pop();
                                // }
                              },
                            ),
                          ),
                        ],
                      )
                      : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Col.primary),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: SizedBox(
                                height: 45,
                                child: Center(
                                  child: Text(
                                    lg.nextTime,
                                    style: TextStyle(color: Col.primary, fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Box(w: 20),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Col.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                updateTheApp(setState2, context, newVersion.fileName ?? '');
                              },
                              child: SizedBox(
                                height: 45,
                                child: Center(
                                  child: Text(
                                    lg.download,
                                    style: const TextStyle(color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  updateTheApp(
    void Function(void Function()) setStat,
    BuildContext context,
    String fileName,
  ) async {
    var link = baseUrl.replaceAll('/api/', '');
    try {
      OtaUpdate().execute('$link/app/$fileName').listen((OtaEvent event) {
        setStat(() {
          percentage = event.value ?? '0';
          status = event.status.name;
        });
        setState(() {
          percentage = event.value ?? '0';
          status = event.status.name;
        });
        if (event.status.name == 'INSTALLING') {
          Navigator.of(context, rootNavigator: true).pop();
        }
      });
    } catch (e) {
      await openInstallPermissionSettings().then((_) {
        updateSheet();
      });
    }
  }

  Future<void> openInstallPermissionSettings() async {
    final intent = AndroidIntent(action: 'android.settings.MANAGE_UNKNOWN_APP_SOURCES');
    await intent.launch();
  }
}
