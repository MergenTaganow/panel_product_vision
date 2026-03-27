import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:panel_image_uploader/core/api.dart';
import 'package:panel_image_uploader/features/items/widgets/search_box_customers.dart';
import 'package:panel_image_uploader/features/items/widgets/sheet.dart';
import '../../../config/colors.dart';
import '../../../config/go.dart';
import '../../../config/helpers.dart';
import '../../../config/routes.dart';
import '../bloc/item_uuid/item_uuid_cubit.dart';
import '../models/item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key? key,
    required this.item,
    this.openSheet,
    this.persentage,
    this.jump,
    this.repricedItem,
    this.isUpsale = false,
    required this.pageType,
  }) : super(key: key);

  final Item? item;
  final bool? openSheet;
  final num? persentage;
  final bool? jump;
  final bool? repricedItem;
  final bool isUpsale;
  final String pageType;

  void _copyToClipboard(String text) {
    // Vibration.vibrate(duration: 100);
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    // IMainRepo mainRepo = sl();
    // String url = mainRepo.sq?.last.getUrl();
    String trend = "";
    String imgUrl = (item?.smallImg?.isNotEmpty ?? false) ? item!.smallImg! : '';
    if ((item?.images ?? []).isNotEmpty && (item?.images?.first?.smallImg?.isNotEmpty ?? false)) {
      imgUrl = item?.images?.first?.smallImg! ?? '';
    }
    if (item?.isMonthlyTrend ?? false) {
      trend = 'month';
    } else if (item?.isWeeklyTrend ?? false) {
      trend = 'week';
    }
    return GestureDetector(
      onTap: () {
        if (openSheet == true) {
          context.read<ItemByUuidForSheet>().getItem(
            uuid: item?.uuid ?? '',
            page: pageType,
            fetchedFromBarcode: false,
            addToHistory: false,
          );

          Sheet().showItem(context, jump: jump ?? false, pageType: pageType);
        } else {
          context.read<ItemUuidCubit>().getItem(
            uuid: item?.uuid ?? '',
            page: pageType,
            fetchedFromBarcode: false,
          );
          Go.to(Routes.itemDetail);
        }
      },
      child: Opacity(
        opacity: (item?.active ?? false) ? 1 : .3,
        child: Stack(
          children: [
            Con(
              marHor: 16,
              padHor: 10,
              col: Col.white,
              shadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Col.black.withOpacity(.2),
                  offset: const Offset(0, 0),
                  spreadRadius: 0,
                ),
              ],
              align: Alignment.topCenter,
              // marHor: 14,
              marVer: 10,
              ch: LayoutBuilder(
                builder: (context, constr) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        height: 86,
                        width: 86,
                        imageUrl: '$baseUrl/images/items/$imgUrl',
                        placeholder:
                            (context, url) =>
                                item?.blurImg != null
                                    ? BlurHash(hash: item!.blurImg!)
                                    : Image.asset('assets/images/place.png', fit: BoxFit.cover),
                        errorWidget:
                            (c, v, d) => Image.asset('assets/images/place.png', fit: BoxFit.cover),
                        fit: BoxFit.contain,
                      ),
                      Box(w: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if ((repricedItem ?? false) && item?.beginDate != null)
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padd(
                                  top: 6,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Col.primary,
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                    child: Text(
                                      "timeAgo(item!.beginDate!, lg)",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Padd(
                              top: 4,
                              child: Box(
                                w: constr.maxWidth - 100,
                                child: GestureDetector(
                                  onLongPress: () => _copyToClipboard(item?.name ?? ''),
                                  child: Text(
                                    item?.name ?? '',
                                    maxLines: 2,
                                    // overflow: true,
                                  ),
                                ),
                              ),
                            ),
                            Box(h: 4),
                            Box(
                              w: constr.maxWidth - 100,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            if (trend == 'month' &&
                                                pageType != NewsTypes.monthlyTrend)
                                              Padd(
                                                right: 5,
                                                child: Svvg.asset('month_item', h: 30),
                                              ),
                                            if (trend == 'week' &&
                                                pageType != NewsTypes.weeklyTrend)
                                              Padd(right: 5, child: Svvg.asset('week_item', h: 30)),
                                            if ((item?.isNew ?? false) &&
                                                pageType != NewsTypes.newItem)
                                              Con(
                                                radius: 5,
                                                padHor: 8,
                                                padVer: 3,
                                                col: Colors.green,
                                                ch: Text(
                                                  lg.neW,
                                                  style: TextStyle(
                                                    color: Col.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        Box(h: 4),
                                        GestureDetector(
                                          onLongPress: () => _copyToClipboard(item?.code ?? ''),
                                          child: Tex(item?.code, con: context).body3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (persentage != null)
                                    Box(
                                      w: 30,
                                      h: 30,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          const Positioned.fill(
                                            child: CircularProgressIndicator(
                                              value: 1,
                                              color: Colors.black45,
                                              strokeWidth: 7,
                                            ),
                                          ),
                                          const Positioned.fill(
                                            child: CircularProgressIndicator(
                                              value: 1,
                                              color: Colors.white,
                                              strokeWidth: 6,
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: CircularProgressIndicator(
                                              value: persentage! / 100,
                                              color: checkColor(persentage!),
                                              strokeWidth: 6,
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Center(
                                              child: Tex("$persentage%", con: context).title3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (isUpsale)
              const Positioned(
                top: 0,
                bottom: 0,
                right: 20,
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Icon(CupertinoIcons.star_circle, color: Colors.yellow, size: 30),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color checkColor(num? percentage) {
    percentage ??= 0;
    if (percentage < 10) {
      return Colors.red;
    } else if (percentage < 30) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  // String timeAgo(DateTime dateTime, AppLocalizations lg) {
  //   Duration difference = DateTime.now().difference(dateTime.toLocal());
  //
  //   if (difference.inDays < 1) {
  //     return lg.today;
  //   } else if (difference.inDays < 7) {
  //     return "${difference.inDays} ${lg.days} ${lg.ago}";
  //   } else {
  //     int weeks = (difference.inDays / 7).floor();
  //     return "$weeks ${lg.week} ${lg.ago}";
  //   }
  // }
}

class NewsTypes {
  static String newItem = 'newItems';
  static String weeklyTrend = 'weeklyTrend';
  static String monthlyTrend = 'monthlyTrend';
}

class Tex extends StatelessWidget {
  final String? text;
  final Color? col;
  final TextAlign? align;
  final BuildContext? con;
  final FontWeight? weight;
  final double? size;
  final bool lineThrough;
  final bool? softWrap;
  final int? maxLines;
  final bool? overflow;
  // ignore: use_key_in_widget_constructors
  const Tex(
    this.text, {
    super.key,
    this.align,
    this.size,
    this.col,
    this.con,
    this.weight,
    this.lineThrough = false,
    this.softWrap,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text ?? '', key: key);
  }

  Text get f34 {
    double ratio =
        (MediaQuery.of(con!).size.width / 360) > 1.2 ? 1.2 : (MediaQuery.of(con!).size.width / 360);
    return Text(
      key: key,
      text ?? '',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: weight ?? FontWeight.w600,
        fontSize: size ?? 34 * ratio,
        color: col ?? Colors.white,
      ),
    );
  }

  Text get h1 {
    double ratio =
        (MediaQuery.of(con!).size.width / 360) > 1.2 ? 1.2 : (MediaQuery.of(con!).size.width / 360);
    return Text(
      key: key,
      text ?? '',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: weight ?? FontWeight.w700,
        fontSize: size ?? 24 * ratio,
        color: col ?? Colors.black87,
      ),
    );
  }

  Text get h11 {
    double ratio =
        (MediaQuery.of(con!).size.width / 360) > 1.2 ? 1.2 : (MediaQuery.of(con!).size.width / 360);
    return Text(
      key: key,
      text ?? '',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: weight ?? FontWeight.w400,
        fontSize: size ?? 22 * ratio,
        color: col ?? Colors.black87,
        decoration: lineThrough ? TextDecoration.lineThrough : null,
      ),
    );
  }

  Text get h2 {
    // double ratio = (MediaQuery.of(con!).size.width / 360)>1.3?1.3:(MediaQuery.of(con!).size.width / 360);
    return Text(
      key: key,
      text ?? '',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: weight ?? FontWeight.w600,
        fontSize: size ?? 18,
        color: col ?? Colors.black87,
        decoration: lineThrough ? TextDecoration.lineThrough : null,
      ),
    );
  }

  Text get h22 {
    double ratio =
        (MediaQuery.of(con!).size.width / 360) > 1.2 ? 1.2 : (MediaQuery.of(con!).size.width / 360);
    return Text(
      key: key,
      text ?? '',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: weight ?? FontWeight.w600,
        fontSize: size ?? 19 * ratio,
        color: col ?? Colors.black87,
        decoration: lineThrough ? TextDecoration.lineThrough : null,
      ),
    );
  }

  Text get h3 {
    // double ratio = (MediaQuery.of(con!).size.width / 360)>1.3?1.3:(MediaQuery.of(con!).size.width / 360);
    return Text(
      key: key,
      text ?? '',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: weight ?? FontWeight.w600,
        fontSize: size ?? 16,
        color: col ?? Colors.black87,
        decoration: lineThrough ? TextDecoration.lineThrough : null,
      ),
    );
  }

  Text get body {
    double ratio =
        (MediaQuery.of(con!).size.width / 360) > 1.2 ? 1.2 : (MediaQuery.of(con!).size.width / 360);
    return Text(
      key: key,
      text ?? '',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: weight ?? FontWeight.w400,
        fontSize: size ?? 16 * ratio,
        color: col ?? Colors.black87,
      ),
    );
  }

  Text get body0 {
    double ratio =
        (MediaQuery.of(con!).size.width / 360) > 1.2 ? 1.2 : (MediaQuery.of(con!).size.width / 360);
    return Text(
      key: key,
      text ?? '',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: weight ?? FontWeight.w400,
        fontSize: size ?? 15 * ratio,
        color: col ?? Colors.black87,
      ),
    );
  }

  Text get body2 {
    double ratio =
        (MediaQuery.of(con!).size.width / 360) > 1.2 ? 1.2 : (MediaQuery.of(con!).size.width / 360);
    return Text(
      key: key,
      text ?? 'no',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: weight ?? FontWeight.w500,
        fontSize: size ?? 14 * ratio,
        color: col ?? Colors.black87,
        decoration: lineThrough ? TextDecoration.lineThrough : null,
      ),
    );
  }

  Text get body3 {
    // double ratio = (MediaQuery.of(con!).size.width / 360)>1.3?1.3:(MediaQuery.of(con!).size.width / 360);
    return Text(
      key: key,
      text ?? '',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: weight ?? FontWeight.w400,
        fontSize: size ?? 14,
        color: col ?? Colors.black87,
      ),
    );
  }

  Text get title1 {
    double ratio =
        (MediaQuery.of(con!).size.width / 360) > 1.2 ? 1.2 : (MediaQuery.of(con!).size.width / 360);
    return Text(
      key: key,
      text ?? '',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: weight ?? FontWeight.w500,
        fontSize: size ?? 12 * ratio,
        color: col ?? Colors.black87,
      ),
    );
  }

  Text get title2 {
    double ratio =
        (MediaQuery.of(con!).size.width / 360) > 1.2 ? 1.2 : (MediaQuery.of(con!).size.width / 360);
    return Text(
      key: key,
      text ?? '',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: weight ?? FontWeight.w400,
        fontSize: size ?? 12 * ratio,
        color: col ?? Colors.black87,
      ),
    );
  }

  Text get title3 {
    double ratio =
        (MediaQuery.of(con!).size.width / 360) > 1.2 ? 1.2 : (MediaQuery.of(con!).size.width / 360);
    return Text(
      key: key,
      text ?? '',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: weight ?? FontWeight.w400,
        fontSize: size ?? 10 * ratio,
        color: col ?? Colors.black87,
      ),
    );
  }

  Text get title4 {
    double ratio =
        (MediaQuery.of(con!).size.width / 360) > 1.2 ? 1.2 : (MediaQuery.of(con!).size.width / 360);
    return Text(
      key: key,
      text ?? '',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: weight ?? FontWeight.w400,
        fontSize: size ?? 8 * ratio,
        color: col ?? Colors.black87,
      ),
    );
  }
}
