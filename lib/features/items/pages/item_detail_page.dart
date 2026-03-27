import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panel_image_uploader/config/helpers.dart';
import 'package:panel_image_uploader/features/global/data/dynamic_localization.dart';
import 'package:panel_image_uploader/features/items/bloc/file_upl_bloc/file_upl_bloc.dart';
import 'package:panel_image_uploader/features/items/models/found_item.dart';
import 'package:panel_image_uploader/features/items/models/item_interesting_type.dart';
import 'package:panel_image_uploader/features/items/widgets/found_item_card.dart';
import '../../../config/colors.dart';
import '../../../config/failure.dart';
import '../../../core/api.dart';
import '../bloc/file_delete_cubit/file_delete_cubit.dart';
import '../bloc/item_uuid/item_uuid_cubit.dart';
import '../bloc/update_image_cubit/update_image_cubit.dart';
import '../widgets/image_full_screen.dart';
import '../widgets/uploading_file.dart';
import 'camera_page.dart';

class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({super.key});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> with SingleTickerProviderStateMixin {
  List<Images?> normalImages = [];
  List<Images?> usageImages = [];
  List<Images?> schemeImages = [];
  List<Images?> embedImages = [];
  String? itemUuid;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FileUplBloc, FileUplState>(
          listener: (context, state) {
            if (state is FileUploadSuccess) {
              print("success came with ${state.type}");
              if (state.type == 'normal') {
                normalImages.add(state.file);
              }
              if (state.type == 'usage') {
                usageImages.add(state.file);
              }
              if (state.type == 'schema') {
                schemeImages.add(state.file);
              }
              if (state.type == 'embed') {
                embedImages.add(state.file);
              }
              setState(() {});
            }
          },
        ),

        BlocListener<ItemUuidCubit, ItemUuidState>(
          listener: (context, state) {
            if (state is ItemUuidSuccess) {
              normalImages = state.item?.images?.where((e) => e?.type == 'normal').toList() ?? [];
              usageImages = state.item?.images?.where((e) => e?.type == 'usage').toList() ?? [];
              schemeImages = state.item?.images?.where((e) => e?.type == 'schema').toList() ?? [];
              embedImages = state.item?.images?.where((e) => e?.type == 'embed').toList() ?? [];
            }
          },
        ),
        BlocListener<UpdateImageCubit, UpdateImageState>(
          listener: (context, state) {
            if (state is MarketAsMainImage) {
              if (state.type == 'normal') {
                setOneMain(normalImages, state.imageUuid);
              }
              if (state.type == 'usage') {
                setOneMain(usageImages, state.imageUuid);
              }
              if (state.type == 'schema') {
                setOneMain(schemeImages, state.imageUuid);
              }
              if (state.type == 'embed') {
                setOneMain(embedImages, state.imageUuid);
              }
              setState(() {});
              // context.read<ItemUuidCubit>().refresh(uuid: itemUuid ?? '');
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text("haryt suraty")),
        body: SafeArea(
          child: BlocBuilder<ItemUuidCubit, ItemUuidState>(
            builder: (context, state) {
              if (state is ItemUuidLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ItemUuidSuccess) {
                itemUuid = state.item?.uuid;
                return Opacity(
                  opacity: (state.item?.active ?? false) ? 1 : .4,
                  child: RefreshIndicator(
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      context.read<ItemUuidCubit>().getItem(
                        uuid: state.item?.uuid ?? '',
                        page: 'search',
                        fetchedFromBarcode: false,
                      );
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ItemCard(
                            item: state.item,
                            pageType: ItemInterestingType.search,
                            openSheet: true,
                          ),
                          Padd(
                            hor: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imagesByType(images: normalImages, type: 'normal'),
                                imagesByType(images: usageImages, type: 'usage'),
                                imagesByType(images: schemeImages, type: 'schema'),
                                imagesByType(images: embedImages, type: 'embed'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (state is ItemUuidFailed) {
                // return itemFailed(rt, context, state, lg);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  void setOneMain(List<Images?> images, String imageUUid) {
    for (var i in images) {
      i?.mainImage = i.uuid == imageUUid;
    }
  }

  Column imagesByType({required List<Images?> images, required String type}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DynamicLocalization.translate(type),
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),

        Box(h: 12),
        BlocBuilder<FileUplBloc, FileUplState>(
          builder: (context, state) {
            List<File> uploadingFiles = [];
            List<double> uploadingValues = [];
            List<File>? errorFiles = [];
            List<Failure>? errors = [];
            if (state is FileUploading && state.type == type) {
              uploadingFiles = state.uploadingFiles.keys.toList();
              uploadingValues = state.uploadingFiles.values.toList();
              errorFiles = state.errorMap?.keys.toList();
              errors = state.errorMap?.values.toList();
            }
            return SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  AddImageButton(type: type, itemUuid: itemUuid ?? ''),
                  Box(w: 8),
                  ...List.generate(images.length, (index) {
                    return Padd(
                      right: 8,
                      child: SingleImage(img: images[index], itemUuid: itemUuid ?? ""),
                    );
                  }),
                  ...List.generate(uploadingFiles.length, (index) {
                    return UploadingImageCard(
                      file: uploadingFiles[index],
                      value: uploadingValues[index],
                      onRemoveTap: () {
                        context.read<FileUplBloc>().add(RemoveFile(uploadingFiles[index]));
                      },
                    );
                  }),
                  ...List.generate(errorFiles?.length ?? 0, (index) {
                    return UploadingImageCard(
                      file: errorFiles![index],
                      failure: errors![index],
                      onRemoveTap: () {
                        print("object");
                        context.read<FileUplBloc>().add(RemoveFile(errorFiles![index]));
                      },
                      onRetryTap: () {
                        context.read<FileUplBloc>().add(
                          RetryFile(file: errorFiles![index], type: type, itemUuid: itemUuid ?? ''),
                        );
                      },
                    );
                  }),
                ],
              ),
            );
          },
        ),
        Box(h: 20),
      ],
    );
  }
}

class SingleImage extends StatelessWidget {
  const SingleImage({super.key, required this.img, required this.itemUuid});

  final Images? img;
  final String itemUuid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return BlocListener<FileDeleteCubit, FileDeleteState>(
              listener: (context, state) {
                if (state is FileDeleteSuccess) {
                  context.read<ItemUuidCubit>().refresh(uuid: itemUuid);
                  Navigator.pop(context);
                }
              },
              child: AlertDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 34),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Svvg.asset('delete'),
                    Text(
                      'Are you sure you want to delete this photo',
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    Box(h: 20),
                    BlocBuilder<FileDeleteCubit, FileDeleteState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            context.read<FileDeleteCubit>().deleteImage(
                              itemUuid: itemUuid,
                              imageUuid: img?.uuid ?? '',
                            );
                          },
                          child: Container(
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFFDF2121),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child:
                                  state is FileDeleteLoading
                                      ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                          valueColor: AlwaysStoppedAnimation(Colors.white),
                                        ),
                                      )
                                      : Text(
                                        "Yes",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                            ),
                          ),
                        );
                      },
                    ),
                    Box(h: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFFDF1F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Col.primary, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) =>
                    FullScreenImageViewer(imageUrl: "$baseUrl/images/items/${img?.bigImg}"),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFA1A1A1).withOpacity(0.5), width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                // height: 100,
                // width: 100,
                imageUrl: '$baseUrl/images/items/${img?.mediumImg}',
                placeholder:
                    (context, url) => Image.asset('assets/images/place.png', fit: BoxFit.cover),
                errorWidget: (c, v, d) => Image.asset('assets/images/place.png', fit: BoxFit.cover),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                if (img?.mainImage ?? false) return;
                context.read<UpdateImageCubit>().makeAsMain(
                  itemUuid: itemUuid,
                  imageUuid: img?.uuid ?? '',
                  type: img?.type ?? '',
                );
              },
              child: Container(
                child: Padd(
                  pad: 3,
                  child: Svvg.asset((img?.mainImage ?? false) ? 'main_image' : 'not_main_image'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddImageButton extends StatelessWidget {
  final String type;
  final String itemUuid;

  const AddImageButton({required this.type, required this.itemUuid, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CameraPage(type: type, itemUuid: itemUuid)),
        );
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFA1A1A1).withOpacity(0.5), width: 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Svvg.asset('add_image'),
              Text("Surat goş", style: TextStyle(fontSize: 12, color: Color(0xFFA1A1A1))),
            ],
          ),
        ),
      ),
    );
  }
}
