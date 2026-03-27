import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/colors.dart';
import '../../../config/helpers.dart';
import '../../global/bloc/sort_cubit/sort_cubit.dart';

enum SearchType { warehouses, trucksByWarehouse, truckItems, showSheet, customers, items }

class SearchBoxScanSort extends StatelessWidget {
  final TextEditingController controller;
  final SearchType? type;
  final void Function(String)? onSubmitted;
  final void Function()? onSort;
  final void Function()? onScan;
  final void Function()? onTap;
  final FocusNode? focusNode;

  const SearchBoxScanSort({
    super.key,
    this.type,
    required this.controller,
    this.onSubmitted,
    this.onScan,
    this.onSort,
    this.onTap,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SearchBar(
        hintText: lg.search,
        controller: controller,
        onTap: onTap,
        focusNode: focusNode,
        hintStyle: MaterialStateProperty.all(TextStyle(color: Col.gray50)),
        constraints: const BoxConstraints(maxWidth: 800.0, minHeight: 45.0),
        padding: MaterialStateProperty.all(const EdgeInsets.only(left: 16)),
        leading: Svvg.asset('_search'),
        elevation: MaterialStateProperty.all(.5),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: const BorderSide(color: Col.borderColor),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Col.white),
        trailing: [
          if (controller.text.trim().isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.text = '';
                if (onSubmitted != null) {
                  onSubmitted!('');
                }
              },
              child: Con(
                pad: 12,
                marRight: 2,
                radius: 6,
                ch: const Icon(Icons.clear, color: Color(0xFF9A9292)),
              ),
            ),
          if (controller.text.trim().isEmpty && onScan != null)
            GestureDetector(
              onTap: onScan,
              child: Con(
                pad: 12,
                marRight: 2,
                radius: 6,
                col: onSort == null ? Col.primary : null,
                ch: Svvg.asset('_scan', color: onSort == null ? Col.white : null),
              ),
            ),
          if (onSort != null)
            GestureDetector(
              onTap: onSort,
              child: Con(
                pad: 12,
                marRight: 2,
                col: Col.primary,
                radius: 6,
                ch: Svvg.asset('_sort', color: Col.white),
              ),
            ),
        ],
        onSubmitted: onSubmitted,
      ),
    );
  }
}

Future<dynamic> radioSelectingSort({
  required BuildContext context,
  required List<Sort> sorts,
  void Function()? onTap,
  required String key,
}) {
  AppLocalizations lg = AppLocalizations.of(context)!;
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SafeArea(
        child: StatefulBuilder(
          builder: (context, setState1) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padd(
                  top: 30,
                  bot: 15,
                  child: Text(
                    lg.sort,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
                BlocBuilder<SortCubit, SortState>(
                  builder: (context, state) {
                    if (state is SortSuccess) {
                      int? selectedSortIndex = sorts.indexWhere(
                        (element) => element.sortBy == state.sort?[key]?.sortBy,
                      );
                      return ListView.builder(
                        itemCount: sorts.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return RadioListTile<int>(
                            title: Text(sorts[index].text ?? ''),
                            value: index,
                            groupValue: selectedSortIndex,
                            // activeColor: Colors.blue, // Customize the active color
                            toggleable: true,
                            onChanged: (int? value) {
                              setState1(() {
                                selectedSortIndex = value;
                                if (selectedSortIndex != null) {
                                  context.read<SortCubit>().selectSort(
                                    key: key,
                                    newSort: sorts[selectedSortIndex!],
                                  );
                                } else {
                                  context.read<SortCubit>().selectSort(key: key, newSort: null);
                                }
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            selectedTileColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
                Box(h: 30),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Col.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padd(
                      child: Center(
                        child: Text(
                          lg.sort,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Box(h: 30),
              ],
            );
          },
        ),
      );
    },
  );
}

class SearchBoxScanFilter extends StatelessWidget {
  final TextEditingController controller;
  final SearchType? type;
  final void Function(String)? onSubmitted;
  final void Function()? onFilter;
  final void Function()? onScan;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final int count;
  const SearchBoxScanFilter({
    super.key,
    required this.controller,
    this.type,
    this.onSubmitted,
    this.onFilter,
    this.onScan,
    this.onTap,
    this.focusNode,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SearchBar(
        hintText: lg.search,
        controller: controller,
        hintStyle: MaterialStateProperty.all(TextStyle(color: Col.gray50)),
        constraints: const BoxConstraints(maxWidth: 800.0, minHeight: 45.0),
        padding: MaterialStateProperty.all(const EdgeInsets.only(left: 16)),
        leading: Svvg.asset('_search'),
        elevation: MaterialStateProperty.all(.5),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: const BorderSide(color: Col.borderColor),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Col.white),
        trailing: [
          if (controller.text.trim().isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.text = '';
                if (onSubmitted != null) {
                  onSubmitted!('');
                }
              },
              child: Con(
                pad: 12,
                marRight: 2,
                radius: 6,
                ch: const Icon(Icons.clear, color: Color(0xFF9A9292)),
              ),
            ),
          if (controller.text.trim().isEmpty && onScan != null)
            GestureDetector(
              onTap: onScan,
              child: Con(
                pad: 12,
                marRight: 2,
                radius: 6,
                col: onScan == null ? Col.primary : null,
                ch: Svvg.asset('_scan', color: onScan == null ? Col.white : null),
              ),
            ),
          GestureDetector(
            onTap: () {
              if (onFilter != null) {
                onFilter!();
              }
            },
            child: Stack(
              children: [
                Con(
                  pad: 12,
                  marRight: 2,
                  col: Col.primary,
                  radius: 6,
                  ch: Svvg.asset('whiteFilter', color: Col.white, h: 21, w: 19),
                ),
                if (count > 0)
                  Positioned(
                    right: 3,
                    top: 3,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        onSubmitted: (str) {
          if (onSubmitted != null) {
            onSubmitted!(str);
          }
        },
      ),
    );
  }
}

class Con extends Container {
  Con({
    Widget? ch,
    Key? key,
    BoxBorder? border,
    double? pad,
    double? padHor,
    double? padVer,
    double? padTop,
    double? padBot,
    double? padLeft,
    double? padRight,
    double? mar,
    double? marHor,
    double? marVer,
    double? marTop,
    double? marBot,
    double? marLeft,
    double? marRight,
    double? radius,
    double? radtopLeft,
    double? radtopRight,
    double? radbotLeft,
    double? radbotRight,
    List<BoxShadow>? shadow,
    Color? col,
    double? h,
    BoxConstraints? cons,
    double? w,
    BoxShape? shape,
    ImageProvider? img,
    BoxFit? imgFit,
    Clip? clip = Clip.hardEdge,
    AlignmentGeometry? align,
  }) : super(
         child: ch,
         margin:
             marHor != null || marVer != null
                 ? EdgeInsets.symmetric(horizontal: marHor ?? 0, vertical: marVer ?? 0)
                 : marTop != null || marBot != null || marRight != null || marLeft != null
                 ? EdgeInsets.only(
                   bottom: marBot ?? 0,
                   left: marLeft ?? 0,
                   right: marRight ?? 0,
                   top: marTop ?? 0,
                 )
                 : mar != null
                 ? EdgeInsets.all(mar)
                 : EdgeInsets.zero,
         clipBehavior: clip!,
         padding:
             padHor != null || padVer != null
                 ? EdgeInsets.symmetric(horizontal: padHor ?? 0, vertical: padVer ?? 0)
                 : padTop != null || padBot != null || padRight != null || padLeft != null
                 ? EdgeInsets.only(
                   bottom: padBot ?? 0,
                   left: padLeft ?? 0,
                   right: padRight ?? 0,
                   top: padTop ?? 0,
                 )
                 : pad != null
                 ? EdgeInsets.all(pad)
                 : EdgeInsets.zero,
         height: h,
         width: w,
         constraints: cons,
         key: key,
         alignment: align,
         decoration: BoxDecoration(
           border: border,
           borderRadius:
               radius != null
                   ? BorderRadius.circular(radius)
                   : (radbotLeft != null ||
                       radbotRight != null ||
                       radtopLeft != null ||
                       radtopRight != null)
                   ? BorderRadius.only(
                     bottomLeft: Radius.circular(radbotLeft ?? 0),
                     bottomRight: Radius.circular(radbotRight ?? 0),
                     topLeft: Radius.circular(radtopLeft ?? 0),
                     topRight: Radius.circular(radtopRight ?? 0),
                   )
                   : null,
           boxShadow: shadow,
           color: col,
           shape: shape ?? BoxShape.rectangle,
           image: img == null ? null : DecorationImage(image: img, fit: imgFit),
         ),
       );
}
