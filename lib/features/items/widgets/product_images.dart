import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:panel_image_uploader/core/api.dart';
import 'package:panel_image_uploader/features/items/widgets/search_box_customers.dart';
import 'package:panel_image_uploader/features/items/widgets/thumbnail.dart';
import 'package:panel_image_uploader/features/items/widgets/video_full_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

import '../../../config/colors.dart';
import '../../../config/helpers.dart';
import '../models/item.dart';
import 'found_item_card.dart';
import 'image_full_screen.dart';

class ProductImages extends StatefulWidget {
  final Item? item;
  const ProductImages({super.key, this.item});

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  late VideoPlayerController videoController;
  final CarouselSliderController _controller = CarouselSliderController();
  List<String> imageUrls = [];
  // String url = '';
  int activePage = 0;
  bool hasVideo = false;

  @override
  void initState() {
    // IMainRepo repo = sl();
    // url = repo.sq?.last.getUrl();
    if (widget.item?.images?.isNotEmpty ?? false) {
      //if there images are not empty
      for (var i in widget.item!.images!) {
        if ((i?.bigImg?.isNotEmpty ?? false) && !imageUrls.contains(i?.bigImg!)) {
          imageUrls.add(i!.bigImg!);
        }
      }
    } else {
      //if images are empty and big images is not empty
      if (widget.item?.bigImg?.isNotEmpty ?? false) imageUrls.add(widget.item!.bigImg!);
    }
    if (widget.item?.video?.isNotEmpty ?? false) {
      // try {
      videoController = VideoPlayerController.network('$baseUrl/videos/items/${widget.item?.video}')
        ..initialize().then((_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              hasVideo = true;
              // videoController.play();
            });
          });
        });
      videoController.addListener(() {
        if (videoController.value.position >= videoController.value.duration) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {});
            _controller.nextPage();
            videoController.seekTo(Duration.zero);
          });
        }
      });
      // }catch(e){
      //   setState(() {
      //     hasVideo = false;
      //   });
      // }
    }
    super.initState();
  }

  @override
  void dispose() {
    if (hasVideo) {
      videoController.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    if (index != imageUrls.length) {
      // Reset video and set auto-play interval back to 10 seconds for images
      if (widget.item?.video?.isNotEmpty ?? false) {
        videoController.pause();
        videoController.seekTo(Duration.zero);
      }
    }
    setState(() {
      activePage = index;
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (videoController.value.isPlaying) {
        videoController.pause();
      } else {
        videoController.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double rt = MediaQuery.of(context).size.width / 360;
    AppLocalizations lg = AppLocalizations.of(context)!;
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: 260,
            autoPlay:
                hasVideo
                    ? videoController.value.isPlaying
                        ? false
                        : true
                    : true,
            autoPlayInterval: const Duration(seconds: 10),
            viewportFraction: 1,
            enableInfiniteScroll: false,
            pauseAutoPlayOnManualNavigate: true,
            onPageChanged: _onPageChanged,
          ),
          items: [
            ///all images
            if (imageUrls.isNotEmpty)
              ...imageUrls
                  .map(
                    (e) => Center(
                      child: Con(
                        padHor: 11 * rt,
                        h: 360,
                        w: MediaQuery.of(context).size.width,
                        col: Colors.white,
                        radbotLeft: 4,
                        radbotRight: 4,
                        ch: Stack(
                          children: [
                            Center(
                              child: CachedNetworkImage(
                                placeholder:
                                    (context, url) =>
                                        widget.item?.blurImg != null
                                            ? BlurHash(hash: widget.item!.blurImg!)
                                            : const CircularProgressIndicator(),
                                errorWidget:
                                    (context, url, error) => Image.asset(
                                      'assets/images/place.png',
                                      height: 360,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                fit: BoxFit.contain,
                                imageUrl: "$baseUrl/images/items/$e",
                              ),
                            ),
                            if (widget.item?.discount != null && widget.item?.discount != 0 ||
                                (widget.item?.isNew ?? false))
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Column(
                                  children: [
                                    if (widget.item?.isNew ?? false)
                                      Con(
                                        h: 30,
                                        w: 70,
                                        col: const Color(0xFFF09090).withOpacity(0.3),
                                        radius: 8,
                                        ch: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Svvg.asset('new'),
                                            Box(w: 2),
                                            Tex(lg.neW, con: context, col: Col.black).body2,
                                          ],
                                        ),
                                      ),
                                    Box(h: 8),
                                    if (widget.item?.discount != null && widget.item?.discount != 0)
                                      Con(
                                        h: 30,
                                        w: 70,
                                        col: const Color(0xFFF09090).withOpacity(0.3),
                                        radius: 8,
                                        ch: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Svvg.asset('discount'),
                                            Box(w: 2),
                                            Tex(
                                              '%${widget.item?.discount?.toString() ?? ''}',
                                              con: context,
                                              col: Col.black,
                                            ).body2,
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            Positioned(
                              bottom: 20,
                              // left: 10,
                              child: Row(
                                children: [
                                  if (widget.item?.isWeeklyTrend ?? false)
                                    Svvg.asset('week_item', h: 30),
                                  Box(w: 6),
                                  if (widget.item?.isMonthlyTrend ?? false)
                                    Svvg.asset('month_item', h: 30),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.fullscreen, color: Col.primary),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) => FullScreenImageViewer(
                                            imageUrl: "$baseUrl/images/items/$e",
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            if (hasVideo == true)
              SizedBox(
                height: 260,
                width: MediaQuery.of(context).size.width - 20,
                child: Stack(
                  children: [
                    Center(
                      child: VideoWidget(
                        controller: videoController,
                        onFullscreen: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => FullscreenVideoPlayer(
                                    controller: videoController,
                                    onClose: () {
                                      videoController.pause();
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                            ),
                          );
                        },
                        onTap: _togglePlayPause,
                      ),
                    ),
                    if (widget.item?.discount != null && widget.item?.discount != 0 ||
                        (widget.item?.isNew ?? false))
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Column(
                          children: [
                            if (widget.item?.isNew ?? false)
                              Con(
                                h: 30,
                                w: 70,
                                col: const Color(0xFFF09090).withOpacity(0.3),
                                radius: 8,
                                ch: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Svvg.asset('new'),
                                    Box(w: 2),
                                    Tex(lg.neW, con: context, col: Col.black).body2,
                                  ],
                                ),
                              ),
                            Box(h: 8),
                            if (widget.item?.discount != null && widget.item?.discount != 0)
                              Con(
                                h: 30,
                                w: 70,
                                col: const Color(0xFFF09090).withOpacity(0.3),
                                radius: 8,
                                ch: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Svvg.asset('discount'),
                                    Box(w: 2),
                                    Tex(
                                      '%${widget.item?.discount?.toString() ?? ''}',
                                      con: context,
                                      col: Col.black,
                                    ).body2,
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    Positioned(
                      bottom: 20,
                      // left: 10,
                      child: Row(
                        children: [
                          if (widget.item?.isWeeklyTrend ?? false) Svvg.asset('week_item', h: 30),
                          Box(w: 6),
                          if (widget.item?.isMonthlyTrend ?? false) Svvg.asset('month_item', h: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (imageUrls.isEmpty)
              Center(
                child: Con(
                  padHor: 11 * rt,
                  h: 360,
                  w: MediaQuery.of(context).size.width,
                  col: Colors.white,
                  radbotLeft: 4,
                  radbotRight: 4,
                  ch: Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/place.png',
                          height: 360,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (widget.item?.discount != null && widget.item?.discount != 0 ||
                          (widget.item?.isNew ?? false))
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Column(
                            children: [
                              if (widget.item?.isNew ?? false)
                                Con(
                                  h: 30,
                                  w: 70,
                                  col: const Color(0xFFF09090).withOpacity(0.3),
                                  radius: 8,
                                  ch: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Svvg.asset('new'),
                                      Box(w: 2),
                                      Tex(lg.neW, con: context, col: Col.black).body2,
                                    ],
                                  ),
                                ),
                              Box(h: 8),
                              if (widget.item?.discount != null && widget.item?.discount != 0)
                                Con(
                                  h: 30,
                                  w: 70,
                                  col: const Color(0xFFF09090).withOpacity(0.3),
                                  radius: 8,
                                  ch: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Svvg.asset('discount'),
                                      Box(w: 2),
                                      Tex(
                                        '%${widget.item?.discount?.toString() ?? ''}',
                                        con: context,
                                        col: Col.black,
                                      ).body2,
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      Positioned(
                        bottom: 20,
                        // left: 10,
                        child: Row(
                          children: [
                            if (widget.item?.isWeeklyTrend ?? false) Svvg.asset('week_item', h: 30),
                            Box(w: 6),
                            if (widget.item?.isMonthlyTrend ?? false)
                              Svvg.asset('month_item', h: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        if (imageUrls.length + (hasVideo ? 1 : 0) > 1)
          Padd(
            top: 15,
            child: SmoothPageIndicator(
              controller: PageController(initialPage: activePage),
              count:
                  imageUrls.length +
                  (hasVideo
                      ? videoController.value.isInitialized
                          ? 1
                          : 0
                      : 0),
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Col.primary,
                dotColor: Colors.grey,
              ),
              onDotClicked: (index) {
                _controller.animateToPage(index); // Navigate to the selected page
              },
            ),
          ),
      ],
    );
  }
}
