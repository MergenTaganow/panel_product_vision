import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import '../../../config/colors.dart';
import '../../../config/go.dart';
import '../../../config/helpers.dart';
import '../../../config/routes.dart';
import '../../../core/api.dart';
import '../../items/bloc/item_uuid/item_uuid_cubit.dart';
import '../../items/models/item.dart';

class Sizes {
  Sizes();
  double dpWidth(BuildContext context) => //for tablet
      MediaQuery.of(context).size.width > 400 ? 400 : MediaQuery.of(context).size.width;

  double? btnWidth(double width) => //for tablet
      width < 400 ? width - 32 : 400;
}

class CustomSnackBar {
  static void showSnackBar({
    required BuildContext context,
    required String title,
    bool isError = false,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    double dpWidth = Sizes().dpWidth(context);
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: isError ? Col.redTask : Col.greenTask,
          duration: duration,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(dpWidth * 0.02)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          showCloseIcon: true,
          closeIconColor: Col.white,
          elevation: dpWidth * 0.01,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.antiAlias,
          content: Row(
            children: [
              Svvg.asset(
                isError ? 'danger' : 'active',
                h: dpWidth * 0.05,
                w: dpWidth * 0.05,
                color: Colors.white,
              ),
              Box(w: dpWidth * 0.03),
              Expanded(
                child: Text(
                  title,
                  maxLines: 5,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // log('Failed to show Snackbar with title:$title');
    }
  }

  static void showYellowSnackBar({
    required BuildContext context,
    required String title,
    Duration duration = const Duration(milliseconds: 4000),
  }) {
    double dpWidth = Sizes().dpWidth(context);
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Col.primYellow,
          duration: duration,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(dpWidth * 0.02)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.symmetric(vertical: 70, horizontal: 15),
          showCloseIcon: true,
          closeIconColor: Col.white,
          elevation: dpWidth * 0.01,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.antiAlias,
          content: Row(
            children: [
              Svvg.asset('danger', h: dpWidth * 0.05, w: dpWidth * 0.05, color: Col.white),
              Box(w: dpWidth * 0.03),
              Flexible(
                child: Text(
                  title,
                  maxLines: 5,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // log('Failed to show Snackbar with title:$title');
    }
  }

  static newDesignSnackBar({
    required BuildContext context,
    required String title,
    required bool isError,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    double dpWidth = Sizes().dpWidth(context);
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          duration: duration,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dpWidth * 0.02),
            side: BorderSide(
              color: isError ? const Color(0xFFD32F2F) : const Color(0xFF1E4620),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
          showCloseIcon: true,
          closeIconColor: Col.white,
          elevation: dpWidth * 0.01,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.antiAlias,
          content: Row(
            children: [
              Svvg.asset(isError ? 'dangerNew' : 'success', h: dpWidth * 0.05, w: dpWidth * 0.05),
              Box(w: dpWidth * 0.03),
              Expanded(
                child: Text(
                  title,
                  maxLines: 5,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isError ? const Color(0xFF5F2120) : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // log('Failed to show Snackbar with title:$title');
    }
  }
}

class BarcodeSnackBars {
  static noAccessSnackBar(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFDF2121),
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
          elevation: 2,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.antiAlias,
          content: Padd(
            ver: 5,
            child: Center(
              child: Text(
                lg.noAccess,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      // log('Failed to show Snackbar with title:$title');
    }
  }

  static Widget itemSnackBar(BuildContext context, Item? item) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    bool itemWithDiscount = item?.discount != null && item?.discount != 0;
    return GestureDetector(
      onTap: () {
        Routes.mainNavKey.currentState!.popUntil((route) => route.isFirst);
        context.read<ItemUuidCubit>().setItem(item: item, fetchedFromBarcode: true);
        Go.to(Routes.itemDetail);
      },
      child: StatefulBuilder(
        builder: (context, set) {
          return SizedBox(
            width: MediaQuery.of(context).size.width - 60,
            height: 130,
            child: Row(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CachedNetworkImage(
                    errorWidget:
                        (c, v, d) => Image.asset('assets/images/place.png', fit: BoxFit.cover),
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) =>
                            item?.blurImg != null
                                ? BlurHash(hash: item!.blurImg!)
                                : Image.asset('assets/images/place.png', fit: BoxFit.cover),
                    imageUrl: "$baseUrl/images/items/${item?.mediumImg}",
                  ),
                ),
                const Box(w: 8),
                Padd(
                  ver: 24,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item?.name ?? '-',
                            style: const TextStyle(fontSize: 15, color: Colors.black),
                            maxLines: 2,
                          ),
                        ),
                        if (item?.price != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                // onLongPress: () {
                                //   context.read<OldPriceSystemCubit>().togglePriceSystem();
                                //   set(() {});
                                // },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (item?.price != null && item?.price != 0)
                                      Text(
                                        item?.getPrice(),
                                        style: TextStyle(
                                          color: itemWithDiscount ? Col.borderColor : Col.primary,
                                          fontSize: itemWithDiscount ? 14 : 15,
                                        ),
                                      ),
                                    if (itemWithDiscount)
                                      Text(
                                        item?.getDiscountPrice(),
                                        style: const TextStyle(color: Col.primary, fontSize: 15),
                                      ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.navigate_next, size: 24, color: Col.primary),
                            ],
                          ),
                        if (item?.price == null)
                          Text(
                            lg.noPrice,
                            style: const TextStyle(color: Col.primary, fontSize: 15),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
