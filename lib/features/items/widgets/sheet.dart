import 'package:flutter/material.dart';
import 'package:panel_image_uploader/features/items/widgets/item_sheet.dart';
import 'package:sliding_sheet2/sliding_sheet2.dart';

class Sheet {
  static bool isOpen = false;

  Future showItem(BuildContext context, {bool jump = false, required String pageType}) {
    return showSlidingBottomSheet(
      context,
      useRootNavigator: true,
      builder: (context) {
        return SlidingSheetDialog(
          elevation: 8,
          cornerRadius: 16,
          duration: const Duration(milliseconds: 50),
          snapSpec: const SnapSpec(
            snap: false,
            snappings: [1.0],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          builder: (context, state) {
            return ItemSheet(jump: jump, pageType: pageType);
          },
        );
      },
    ).then((value) => false);
  }

  // Future showImageSearchResult(BuildContext context) {
  //   return showModalBottomSheet(
  //     context: context,
  //     isDismissible: true,
  //     useRootNavigator: true,
  //     useSafeArea: true,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(15),
  //         topRight: Radius.circular(15),
  //       ),
  //     ),
  //     builder: (context) {
  //       return DraggableScrollableSheet(
  //         maxChildSize: 0.95,
  //         initialChildSize: 0.8,
  //         minChildSize: 0.7,
  //         expand: false,
  //         builder: (BuildContext context, ScrollController scrollController) {
  //           return ImageSearchSheet(scrollController);
  //         },
  //       );
  //     },
  //   );
  // }

  // Future showPrintSettings(BuildContext context, {String? type}) {
  //   return showModalBottomSheet(
  //       context: context,
  //       isDismissible: true,
  //       useRootNavigator: true,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(15),
  //           topRight: Radius.circular(15),
  //         ),
  //       ),
  //       isScrollControlled: true,
  //       builder: (context) {
  //         return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
  //           return PrintSettingsSheet(printingType: type);
  //         });
  //       });
  // }

  // Future showCAmeraController(BuildContext context, Function() onResult) {
  //   AppLocalizations lg = AppLocalizations.of(context)!;
  //   return showModalBottomSheet(
  //       context: context,
  //       isDismissible: true,
  //       useRootNavigator: true,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(10),
  //           topRight: Radius.circular(10),
  //         ),
  //       ),
  //       isScrollControlled: true,
  //       builder: (context) => SafeArea(
  //             child: Container(
  //               height: MediaQuery.of(context).size.height - 100,
  //               color: Col.white,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Svvg.asset('emptyQR'),
  //                   Box(h: 20),
  //                   Center(child: Tex(lg.readItemQr, con: context).body),
  //                   Box(h: 20),
  //                   Center(
  //                       child: EBtn(
  //                     h: 45 * R.atio,
  //                     wi: 160 * R.atio,
  //                     lg: lg,
  //                     rt: R.atio,
  //                     text: lg.btnReadQr,
  //                     weight: FontWeight.w600,
  //                     onTap: () {
  //                       onResult();
  //                       Navigator.of(context, rootNavigator: true).pop(false);
  //                       return false;
  //                     },
  //                   )),
  //                 ],
  //               ),
  //             ),
  //           )).then((value) {
  //     onResult();
  //   });
  // }

  static Future showAnaliz(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isDismissible: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => Container(),
      // builder: (context) => Container(
      //   height: 400,
      //   color: Colors.red,
      // ),
    );
  }
}
