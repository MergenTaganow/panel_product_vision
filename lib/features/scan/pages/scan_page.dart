import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../config/helpers.dart';
import '../../auth/widgets/change_lang.dart';
import '../bloc/barcode_data_fetcher/barcode_data_fetcher_cubit.dart';
import '../widgets/custom_snack_bar.dart';
import '../widgets/scan_animation.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => ScanPageState();
}

class ScanPageState extends State<ScanPage> with TickerProviderStateMixin {
  Timer? timer;
  DateTime? dataTime;
  bool sheetController = true;
  static QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  late AnimationController cardAnimationController;
  Offset tBegin = const Offset(0, 1);
  late DateTime lastDateTime;
  final StreamController<double> _strController = StreamController<double>.broadcast();
  late Stream<double> opacityStream;
  double currentOffset = 0;
  Widget? animatingChild;
  double cardBottom = 40;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    repeat();
    opacityStream = _strController.stream;
    lastDateTime = DateTime.now();
    cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    super.initState();
  }

  @override
  void dispose() {
    cardAnimationController.dispose();
    controller?.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ScanPage oldWidget) {
    cardAnimationController.reverse();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double rt = MediaQuery.of(context).size.width / 360;
    // AppLocalizations lg = AppLocalizations.of(context)!;
    return MultiBlocListener(
      listeners: [
        BlocListener<BarcodeDataFetcherCubit, BarcodeDataFetcherState>(
          listener: (context, state) {
            // if (state is BarcodeDataWasAlOrder) {
            //   setState(() {
            //     animatingChild = BarcodeSnackBars.alOrderSnackBar(context, state.alOrder);
            //     cardBottom = 50;
            //   });
            //   cardAnimationController.forward().then((result) {
            //     tBegin = const Offset(0, -1);
            //   });
            // }
            // if (state is BarcodeDataWasGapak) {
            //   setState(() {
            //     animatingChild = BarcodeSnackBars.gapakSnackBar(context, state.gapak);
            //     cardBottom = 40;
            //   });
            //   cardAnimationController.forward().then((result) {
            //     tBegin = const Offset(0, -1);
            //   });
            // }
            // if (state is BarcodeDataFetcherFailed) {
            //   CustomSnackBar.newDesignSnackBar(
            //       context: context, title: lg.barcodeIncorrect, isError: true);
            // }
            //
            // if (state is BarcodeDataWasMbOrder) {
            //   setState(() {
            //     animatingChild = BarcodeSnackBars.mbOrderSnackBar(context, state.mbOrder);
            //     cardBottom = 50;
            //   });
            //   cardAnimationController.forward().then((result) {
            //     tBegin = const Offset(0, -1);
            //   });
            // }
            //
            // if (state is BarcodeDataWasMbProduct) {
            //   setState(() {
            //     animatingChild = BarcodeSnackBars.mbProductSnackBar(context, state.mbProduct);
            //     cardBottom = 50;
            //   });
            //   cardAnimationController.forward().then((result) {
            //     tBegin = const Offset(0, -1);
            //   });
            // }
            if (state is BarcodeDataWasItem) {
              setState(() {
                animatingChild = BarcodeSnackBars.itemSnackBar(context, state.item);
                cardBottom = 50;
              });
              cardAnimationController.forward().then((result) {
                tBegin = const Offset(0, -1);
              });
            }
          },
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: scanAppBar(context, rt),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Stack(
            children: [
              QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 270,
                ),
                onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
              ),
              const ScannerAnimatedWidget(),
              if (animatingChild != null)
                Positioned(bottom: 0, right: 0, left: 0, child: _animationCard(animatingChild)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _animationCard(Widget? child) {
    return AnimatedBuilder(
      animation: cardAnimationController,
      builder: (context, _) {
        return SlideTransition(
          position: Tween<Offset>(begin: tBegin, end: Offset.zero).animate(cardAnimationController),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.horizontal,
                  onDismissed: (_) {
                    cardAnimationController.reset();
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity:
                        cardAnimationController.value == 1
                            ? cardAnimationController.value
                            : cardAnimationController.value < 0.2
                            ? 0
                            : cardAnimationController.value / 1.5,
                    child: StreamBuilder<double>(
                      stream: opacityStream,
                      initialData: 1.0,
                      builder: (context, snapshot) {
                        return Listener(
                          child: Opacity(
                            opacity: snapshot.data!,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 12,
                              child: GestureDetector(
                                onTap: () {
                                  cardAnimationController.reverse();
                                  changesheetController(false);
                                  controller?.pauseCamera();
                                  dataTime = DateTime.now();

                                  // Go.to(Routes.itemDetail).then((value) {
                                  //   controller?.resumeCamera();
                                  //   changesheetController(true);
                                  // });
                                },
                                child: animatingChild,
                              ),
                            ),
                          ),
                          onPointerUp: (value) {
                            _strController.add(1);
                          },
                          onPointerHover: (value) {
                            log(value.position.dx.toString());
                            currentOffset = value.position.dx;
                          },
                          onPointerMove: (value) {
                            log(value.position.dx.toString());
                            var opacity = (value.position.dx - currentOffset).abs() / 200;

                            if (opacity > 1) opacity = 1;
                            log(opacity.toString());
                            _strController.add(1 - opacity);
                          },
                        );
                      },
                    ),
                  ),
                ),
                Box(h: cardBottom),
              ],
            ),
          ),
        );
      },
    );
  }

  void repeat() {
    dataTime = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      // log((dataTime?.difference(DateTime.now()).inMinutes ?? -1).toString());
      if ((dataTime?.difference(DateTime.now()).inMinutes ?? -1) == -5 && sheetController) {
        controller?.pauseCamera();
        changesheetController(false);
        timer?.cancel();
        // Sheet().showCAmeraController(context, () {
        //   controller?.resumeCamera();
        //   dataTime = DateTime.now();
        //   timer?.cancel();
        //   repeat();
        //   changesheetController(true);
        // });
        timer?.cancel();
      }
    });
  }

  void changesheetController(bool i) {
    setState(() {
      sheetController = i;
    });
  }

  void _onQRViewCreated(QRViewController controlle) {
    setState(() {
      controller = controlle;
      controlle.resumeCamera();
    });

    controller?.scannedDataStream.listen((scanData) {
      //DO some logic here for checking item
      if (sheetController &&
          scanData.code != null &&
          lastDateTime.difference(DateTime.now()).inSeconds.abs() > 2) {
        lastDateTime = DateTime.now();
        context.read<BarcodeDataFetcherCubit>().fetchBarcodeData(barcodeData: scanData.code!);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('no Permission')));
    }
  }

  AppBar scanAppBar(BuildContext context, double rt) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return AppBar(title: Text(lg.productQR), actions: const [EditLang()]);
  }
}
