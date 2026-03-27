import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:panel_image_uploader/core/api.dart';
import 'package:panel_image_uploader/features/items/widgets/product_images.dart';
import 'package:panel_image_uploader/features/items/widgets/search_box_customers.dart';
import 'package:panel_image_uploader/features/items/widgets/simplest_quill_editor.dart';
import '../../../config/colors.dart';
import '../../../config/helpers.dart';
import '../../auth/bloc/aut_bloc/auth_bloc.dart';
import '../bloc/item_uuid/item_uuid_cubit.dart';
import '../models/found_item.dart';
import 'found_item_card.dart';

class ItemInDetail extends StatefulWidget {
  final ItemUuidSuccess itemState;
  const ItemInDetail({Key? key, required this.itemState}) : super(key: key);

  @override
  State<ItemInDetail> createState() => _ItemInDetailState();
}

class _ItemInDetailState extends State<ItemInDetail> {
  Images? images;
  QuillController controller = QuillController.basic();

  void _copyToClipboard(String text) {
    // Vibration.vibrate(duration: 100);
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  void initState() {
    if (widget.itemState.item?.info?.trim().isNotEmpty ?? false) {
      controller.document = Document.fromDelta(
        convertMarkdownToDelta(widget.itemState.item?.info?.trim() ?? ''),
      );
    }
    controller.readOnly = true;
    // html = Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    //   child: HtmlWidget(
    //     "${widget.itemState.item?.info?.replaceAll('&lt;', '<')}",
    //   ),
    // );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthState authSt = context.read<AuthBloc>().state;
    double rt = MediaQuery.of(context).size.width / 360;
    AppLocalizations lg = AppLocalizations.of(context)!;
    bool productWithDiscount =
        widget.itemState.item?.discount != null && widget.itemState.item?.discount != 0;
    bool countchecker =
        widget.itemState.item?.unitCount != null && widget.itemState.item!.unitCount! != 1;
    var list = {
      'best': {'tr': "Kop satylan", 'ru': "Лучшая продажа", 'en': "Kop satylan"},
      'middle': {'tr': "Ortaca satylan", 'ru': "Средний продажа", 'en': "Orta satylan"},
      'least': {'tr': "Az satylan", 'ru': "Мало продажа", 'en': "Az satylan"},
    };
    var localparetto = list[widget.itemState.item?.paretto.toString()]?[lg.localeName] ?? '';
    // var url = sl<IMainRepo>().sq?.last.getUrl();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ProductImages(item: widget.itemState.item),
          Box(h: 10 * rt),
          Padd(
            hor: 16 * rt,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // UserView(
                //   afterRemove: () {
                //     context.read<ItemUuidCubit>().getItem(
                //         uuid: widget.itemState.item?.uuid ?? '',
                //         page: ItemInterestingType.byScan,
                //         fetchedFromBarcode: false);
                //   },
                // ),
                GestureDetector(
                  onLongPress: () => _copyToClipboard(widget.itemState.item?.name ?? ''),
                  child:
                      Tex(
                        widget.itemState.item?.erpName ?? widget.itemState.item?.name ?? '',
                        con: context,
                      ).body,
                ),
                Box(h: 7 * rt),

                // per  price
                if (widget.itemState.item?.price != null && widget.itemState.item?.price != 0)
                  GestureDetector(
                    onLongPress: () {
                      // context.read<OldPriceSystemCubit>().togglePriceSystem();
                      // setState(() {});
                    },
                    child: Row(
                      children: [
                        badge(
                          context: context,
                          text: widget.itemState.item?.getSingleUnit() ?? '',
                          color: Colors.white,
                        ),
                        // if (widget.itemState.item?.discount != null &&
                        //     widget.itemState.item?.discount != 0)
                        Expanded(
                          child:
                              Tex(
                                widget.itemState.item?.getPrice(),
                                con: context,
                                col: productWithDiscount ? Col.passiveGreyAnti : Col.primary,
                                lineThrough: productWithDiscount ? true : false,
                                align: TextAlign.center,
                              ).h2,
                        ),
                        if (productWithDiscount)
                          Expanded(
                            child:
                                Tex(
                                  widget.itemState.item?.getDiscountPrice(),
                                  con: context,
                                  col: Col.primary,
                                  align: TextAlign.center,
                                ).h2,
                          ),
                      ],
                    ),
                  ),
                if (widget.itemState.item?.price == null || widget.itemState.item?.price == 0)
                  Tex(lg.noPrice, con: context, col: Col.primary).h2,
                Box(h: 7 * rt),
                // total count price
                if (countchecker && widget.itemState.item?.price != null)
                  GestureDetector(
                    onLongPress: () {
                      // context.read<OldPriceSystemCubit>().togglePriceSystem();
                      // setState(() {});
                    },
                    child: Row(
                      children: [
                        badge(context: context, text: widget.itemState.item?.getUnit() ?? ''),
                        Expanded(
                          child:
                              Tex(
                                widget.itemState.item?.getPriceTotal(),
                                con: context,
                                col: productWithDiscount ? Col.passiveGreyAnti : Col.primary,
                                lineThrough: productWithDiscount ? true : false,
                                align: TextAlign.center,
                              ).h2,
                        ),
                        if (productWithDiscount)
                          Expanded(
                            child:
                                Tex(
                                  widget.itemState.item?.getDiscountTotal(),
                                  con: context,
                                  col: Col.primary,
                                  align: TextAlign.center,
                                ).h2,
                          ),
                      ],
                    ),
                  ),
                Box(h: 15 * rt),
                if (widget.itemState.item?.code != null)
                  infoRow(
                    context: context,
                    title: lg.code,
                    desc: widget.itemState.item?.code ?? '#####',
                  ),
                if (widget.itemState.item?.brandImage != null)
                  infoRow(
                    context: context,
                    title: lg.brands,
                    child: CachedNetworkImage(
                      height: 35,
                      // width: MediaQuery.of(context).size.width - 40,
                      placeholder:
                          (context, url) =>
                              widget.itemState.item?.blurImg != null
                                  ? BlurHash(hash: widget.itemState.item!.blurImg!)
                                  : Image.asset('assets/images/place.png', fit: BoxFit.cover),
                      fit: BoxFit.contain,
                      errorWidget:
                          (c, v, d) => Center(
                            child: Text(
                              widget.itemState.item?.brand ?? '',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                      imageUrl: "$baseUrl/api/images/brands/${widget.itemState.item?.brandImage}",
                    ),
                  )
                else if (widget.itemState.item?.brand != null)
                  infoRow(
                    context: context,
                    title: lg.brands,
                    desc: widget.itemState.item?.brand ?? '#####',
                  ),
                if (widget.itemState.item?.lastGroup?.name != null)
                  infoRow(
                    context: context,
                    title: lg.category,
                    desc: widget.itemState.item?.lastGroup?.name ?? '',
                  ),
                if (widget.itemState.item?.unit != null)
                  infoRow(
                    context: context,
                    title: lg.unit,
                    desc: widget.itemState.item?.unit.toString() ?? '--',
                  ),
                infoRow(
                  context: context,
                  title: lg.ozelCode,
                  desc: widget.itemState.item?.specode ?? 'ADATY',
                ),
                if (widget.itemState.item?.unit != null)
                  infoRow(context: context, title: lg.paretto, desc: localparetto),
                if (widget.itemState.item?.rating != null &&
                    widget.itemState.item?.rating != 0 &&
                    widget.itemState.item?.commentCount != 0)
                  infoRow(
                    context: context,
                    title: 'reviews',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RatingBar.builder(
                          initialRating: widget.itemState.item!.rating!.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemSize: 24,
                          allowHalfRating: true,
                          ignoreGestures: true,
                          itemCount: 5,
                          // itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {},
                        ),
                        Padd(left: 10, right: 6, child: Svvg.asset('review')),
                        Text(
                          widget.itemState.item?.commentCount.toString() ?? '',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),

                if (widget.itemState.item?.name != null &&
                    widget.itemState.item?.name !=
                        (widget.itemState.item?.erpName ?? widget.itemState.item?.name ?? ''))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${lg.name}: ',
                        style: TextStyle(
                          color: Col.gray50,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        widget.itemState.item?.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Divider(height: 1 * rt, color: Col.gray50),
                      Box(h: 15 * rt),
                    ],
                  ),
              ],
            ),
          ),
          Padd(hor: 16, child: OnlyQuillEditor(controller)),
          // if (authSt is AuthSuccess && (authSt.user.viewPurchaseInfo ?? false)) purchases(lg),
        ],
      ),
    );
  }

  // Column purchases(AppLocalizations lg) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       if (widget.itemState.item?.firstPurchaseDate != null ||
  //           widget.itemState.item?.firstPurchaseAmount != null ||
  //           widget.itemState.item?.firstPurchaseTMT != null ||
  //           widget.itemState.item?.firstPurchaseUSD != null ||
  //           widget.itemState.item?.firstPurchaseID != null)
  //         ExpansionTile(
  //           textColor: Col.primary,
  //           collapsedTextColor: Col.primary,
  //           collapsedIconColor: Col.primary,
  //           iconColor: Col.primary,
  //           initiallyExpanded: true,
  //           childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
  //           title: Text(lg.firstPurchase,
  //               style:
  //                   const TextStyle(color: Col.primary, fontSize: 16, fontWeight: FontWeight.w500)),
  //           children: [
  //             Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(6),
  //                 border: Border.all(color: const Color(0xFF808080).withOpacity(0.55), width: 1),
  //               ),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   if (widget.itemState.item?.firstPurchaseDate != null)
  //                     singleTile(
  //                       title: lg.date,
  //                       value: DateFormat('yyyy.MM.dd')
  //                           .format(widget.itemState.item!.firstPurchaseDate!),
  //                     ),
  //                   if (widget.itemState.item?.firstPurchaseAmount != null)
  //                     singleTile(
  //                       title: lg.quantity,
  //                       value: widget.itemState.item?.firstPurchaseAmount.toString() ?? '',
  //                     ),
  //                   if (widget.itemState.item?.firstPurchaseTMT != null)
  //                     singleTile(
  //                       title: "${lg.price} TMT",
  //                       value: '${widget.itemState.item?.firstPurchaseTMT?.toStringAsFixed(2)} TMT',
  //                     ),
  //                   if (widget.itemState.item?.firstPurchaseUSD != null)
  //                     singleTile(
  //                       title: '${lg.price} USD',
  //                       value: '${widget.itemState.item?.firstPurchaseUSD?.toStringAsFixed(4)} USD',
  //                     ),
  //                   if (widget.itemState.item?.firstPurchaseID != null)
  //                     singleTile(
  //                       title: '${lg.price} ${widget.itemState.item?.firstPurchaseIDCode}',
  //                       value:
  //                           '${widget.itemState.item?.firstPurchaseID} ${widget.itemState.item?.firstPurchaseIDCode}',
  //                       bottomLine: false,
  //                     ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       if (widget.itemState.item?.lastPurchaseDate != null ||
  //           widget.itemState.item?.lastPurchaseAmount != null ||
  //           widget.itemState.item?.lastPurchaseTMT != null ||
  //           widget.itemState.item?.lastPurchaseUSD != null ||
  //           widget.itemState.item?.lastPurchaseID != null)
  //         ExpansionTile(
  //           textColor: Col.primary,
  //           collapsedTextColor: Col.primary,
  //           collapsedIconColor: Col.primary,
  //           iconColor: Col.primary,
  //           initiallyExpanded: true,
  //           childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
  //           title: Text(lg.lastPurchase,
  //               style:
  //                   const TextStyle(color: Col.primary, fontSize: 16, fontWeight: FontWeight.w500)),
  //           children: [
  //             Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(6),
  //                 border: Border.all(color: const Color(0xFF808080).withOpacity(0.55), width: 1),
  //               ),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   if (widget.itemState.item?.lastPurchaseDate != null)
  //                     singleTile(
  //                       title: lg.date,
  //                       value: DateFormat('yyyy.MM.dd')
  //                           .format(widget.itemState.item!.lastPurchaseDate!),
  //                     ),
  //                   if (widget.itemState.item?.lastPurchaseAmount != null)
  //                     singleTile(
  //                       title: lg.quantity,
  //                       value: widget.itemState.item?.lastPurchaseAmount.toString() ?? '',
  //                     ),
  //                   if (widget.itemState.item?.lastPurchaseTMT != null)
  //                     singleTile(
  //                       title: "${lg.price} TMT",
  //                       value: '${widget.itemState.item?.lastPurchaseTMT?.toStringAsFixed(2)} TMT',
  //                     ),
  //                   if (widget.itemState.item?.lastPurchaseUSD != null)
  //                     singleTile(
  //                       title: '${lg.price} USD',
  //                       value: '${widget.itemState.item?.lastPurchaseUSD?.toStringAsFixed(4)} USD',
  //                     ),
  //                   if (widget.itemState.item?.lastPurchaseID != null)
  //                     singleTile(
  //                       title: '${lg.price} ${widget.itemState.item?.lastPurchaseIDCode}',
  //                       value:
  //                           '${widget.itemState.item?.lastPurchaseID} ${widget.itemState.item?.lastPurchaseIDCode}',
  //                       bottomLine: false,
  //                     ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       Box(h: 30),
  //     ],
  //   );
  // }

  Widget singleTile({required String title, required String value, bool bottomLine = true}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padd(
          ver: 8,
          hor: 16,
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(color: Col.gray50, fontSize: 16, fontWeight: FontWeight.w400),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        if (bottomLine) Divider(color: const Color(0xFF808080).withOpacity(0.55), height: 1),
      ],
    );
  }

  Widget infoRow({
    required BuildContext context,
    required String title,
    String? desc,
    Widget? child,
  }) {
    double rt = MediaQuery.of(context).size.width / 360;
    return Padd(
      ver: 2 * rt,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: Col.gray50, fontWeight: FontWeight.w500, fontSize: 15),
              ),
              child ??
                  Expanded(
                    child: GestureDetector(
                      onLongPress: () {
                        // if (AppLocalizations.of(context)!.code == title) {
                        //   _copyToClipboard(desc);
                        // }
                      },
                      child: Text(
                        desc!,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
          Padd(top: 6, bot: 8, child: Divider(color: Col.gray50, height: 1)),
        ],
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
      radius: 6,
      padHor: 10,
      padVer: 10,
      col: Col.transparent,
      border: Border.all(color: Col.gray50.withOpacity(0.5), width: 0.5),
      ch: Tex(text, col: Colors.black, weight: FontWeight.w500, size: 15, con: context).title2,
    );
  }
}
