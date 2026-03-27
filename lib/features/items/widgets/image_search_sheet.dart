// import 'package:dukanda/config/exp.dart';
// import 'package:dukanda/data/i_services/item_interesting_type.dart';
// import 'package:dukanda/presentation/bloc/search_by_image_cubit/search_by_image_cubit.dart';
// import 'package:dukanda/presentation/pages/scan/widgets/found_item_card.dart';
//
// class ImageSearchSheet extends StatefulWidget {
//   final ScrollController scrollController;
//   const ImageSearchSheet(this.scrollController, {super.key});
//
//   @override
//   State<ImageSearchSheet> createState() => _ImageSearchSheetState();
// }
//
// class _ImageSearchSheetState extends State<ImageSearchSheet> {
//   @override
//   Widget build(BuildContext context) {
//     AppLocalizations lg = AppLocalizations.of(context)!;
//
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Padd(
//             ver: 10,
//             child: Text(
//               lg.similar,
//               style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
//             )),
//         Expanded(
//           child: BlocBuilder<SearchByImageCubit, SearchByImageState>(
//             builder: (context, state) {
//               print(state);
//               if (state is SearchByImageLoading) {
//                 return Center(
//                     child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                         height: 60,
//                         width: 60,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 3,
//                           backgroundColor: Color(0xFFE4E4E4),
//                           color: Color(0xFF6979F8),
//                         )),
//                     Box(h: 20),
//                     Text("Finding similar objects", style: TextStyle(fontSize: 17)),
//                   ],
//                 ));
//               }
//               if (state is SearchByImageSuccess) {
//                 if (state.items.isEmpty) {
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Svvg.asset('emptyList'),
//                       Box(h: 20),
//                       Text(
//                         "Nothing has found.\nPlease try again",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 17),
//                       )
//                     ],
//                   );
//                 }
//
//                 return ListView.builder(
//                   controller: widget.scrollController,
//                   itemBuilder: (context, index) {
//                     return Padd(
//                         bot: index == state.items.length - 1 ? 50 : 0,
//                         child: ItemCard(
//                             item: state.items[index], pageType: ItemInterestingType.search));
//                   },
//                   itemCount: state.items.length,
//                 );
//               }
//               return Container();
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
