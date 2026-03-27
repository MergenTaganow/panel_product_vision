import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:panel_image_uploader/features/items/widgets/search_box_customers.dart';
import 'package:panel_image_uploader/features/items/widgets/simplest_quill_editor.dart';

import '../../../config/colors.dart';
import '../../../config/go.dart';
import '../../../config/helpers.dart';
import '../../../config/routes.dart';
import '../bloc/item_uuid/item_uuid_cubit.dart';
import '../models/found_item.dart';
import 'found_item_card.dart';
import 'item_in_detail.dart';
// import 'package:flutter_html/flutter_html.dart';

class ItemSheet extends StatefulWidget {
  final bool jump;
  final String pageType;
  const ItemSheet({Key? key, this.jump = false, required this.pageType}) : super(key: key);

  @override
  State<ItemSheet> createState() => ItemSheetState();
}

checkOrien() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class ItemSheetState extends State<ItemSheet> {
  String url = '';

  @override
  void initState() {
    checkOrien();
    super.initState();
  }

  late ScrollController controller;

  void _copyToClipboard(String text) {
    // Vibration.vibrate(duration: 100);
    Clipboard.setData(ClipboardData(text: text));
  }

  Images? images;
  QuillController infoController = QuillController.basic();

  @override
  void dispose() {
    infoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double rt = MediaQuery.of(context).size.width / 360;
    AppLocalizations lg = AppLocalizations.of(context)!;
    // IMainRepo mainRepo = sl();
    // url = mainRepo.sq?.last.getUrl();
    return BlocListener<ItemByUuidForSheet, ItemUuidState>(
      listener: (context, state) {
        if (state is ItemUuidSuccess) {
          if (state.item?.info?.trim().isNotEmpty ?? false) {
            infoController.document = Document.fromDelta(
              convertMarkdownToDelta(state.item?.info?.trim() ?? ''),
            );
          }
          infoController.readOnly = true;
          // html = HtmlWidget("${state.item?.info?.replaceAll('&lt;', '<')}");
        }
      },
      child: SafeArea(
        child: BlocBuilder<ItemByUuidForSheet, ItemUuidState>(
          builder: (context, state) {
            if (state is ItemUuidLoading) {
              return Con(
                cons: BoxConstraints(minHeight: 600 * rt),
                ch: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [Center(child: CircularProgressIndicator())],
                ),
              );
            } else if (state is ItemUuidSuccess) {
              return Material(
                child: Con(
                  radtopLeft: 10,
                  radtopRight: 10,
                  col: Col.itemBackg,
                  cons: BoxConstraints(minHeight: 600 * rt),
                  padVer: 15 * rt,
                  ch: Column(children: [ItemInDetail(itemState: state)]),
                ),
              );
            } else if (state is ItemUuidFailed) {
              return Material(
                child: Con(
                  cons: BoxConstraints(minHeight: 600 * rt),
                  ch: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Box(h: 15),
                      Box(w: 50 * rt, h: 4 * rt, child: ColoredBox(color: Col.borderColor)),
                      Box(h: 50),
                      // Center(
                      //   child: Lottie.asset(
                      //     "assets/lotties/empty_box.json",
                      //     height: 150,
                      //     width: 150,
                      //     fit: BoxFit.contain,
                      //   ),
                      // ),
                      Center(
                        child: Tex(lg.itemNotFound, con: context, align: TextAlign.center).body,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Box();
            }
          },
        ),
      ),
    );
  }

  Widget badge({
    required BuildContext context,
    required String text,
    Color? color,
    Color? textCol,
  }) {
    return Con(
      radius: 5,
      padHor: 8,
      padVer: 6,
      col: color ?? Col.passiveGreyAnti,
      ch: Tex(' $text', col: textCol ?? Col.white, weight: FontWeight.w500, con: context).title2,
    );
  }

  double getImageWidth(bool checker, BuildContext context, double rt) {
    return checker
        ? MediaQuery.of(context).size.width - 75 * rt
        : MediaQuery.of(context).size.width;
  }

  double getBigImageHeight(BuildContext context, double rt) {
    return MediaQuery.of(context).size.width - 20 * rt;
  }

  Widget countBadge(int count, BuildContext context, String unit) {
    return Con(
      radius: 8,
      padHor: 8,
      padVer: 6,
      col: Col.passiveGreyAnti,
      ch: Tex(' $unit', col: Col.white, weight: FontWeight.w500, con: context).title2,
    );
  }

  Widget infoRow(BuildContext context, String title, String desc) {
    double rt = MediaQuery.of(context).size.width / 360;
    return Padd(
      ver: 2 * rt,
      child: Row(
        children: [
          Box(w: 100 * rt, child: Tex(title, con: context).body3),
          Box(
            w: 200 * rt,
            child: GestureDetector(
              onLongPress: () {
                // if (AppLocalizations.of(context)!.code == title) {
                //   _copyToClipboard(desc);
                // }
              },
              child: Tex(desc, con: context).body3,
            ),
          ),
        ],
      ),
    );
  }
}
