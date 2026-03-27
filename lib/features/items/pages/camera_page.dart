import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart' as CAM;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../config/go.dart';
import '../../../config/helpers.dart';
import '../bloc/file_upl_bloc/file_upl_bloc.dart';
import '../widgets/found_item_card.dart';
import '../widgets/search_box_customers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late List<CAM.CameraDescription> cameras;

class CameraPage extends StatefulWidget {
  final String type;
  final String itemUuid;
  const CameraPage({super.key, required this.itemUuid, required this.type});

  @override
  State<CameraPage> createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> with TickerProviderStateMixin {
  CAM.CameraController imageCameraController = CAM.CameraController(
    cameras[0],
    CAM.ResolutionPreset.max,
  );

  @override
  void initState() {
    imageCameraController
        .initialize()
        .then((_) async {
          if (!mounted) {
            return;
          }
          setState(() {});
        })
        .catchError((Object e) {
          if (e is CAM.CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                // Handle access errors here.
                break;
              default:
                // Handle other errors here.
                break;
            }
          }
        });

    super.initState();
  }

  @override
  void dispose() {
    imageCameraController.dispose();
    Go.emptyCurrent();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double rt = MediaQuery.of(context).size.width / 360;
    // AppLocalizations lg = AppLocalizations.of(context)!;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: scanAppBar(context, rt),
      extendBodyBehindAppBar: true,
      body: _imageCameraView(),
    );
  }

  Widget _imageCameraView() {
    if (!imageCameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Camera background with proper aspect ratio
          CAM.CameraPreview(imageCameraController),
          // Capture button
          Positioned(
            bottom: 20,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 25),
                Center(
                  child: GestureDetector(
                    onTap: _captureImage,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 5),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          type: FileType.image,
                        );

                        if (result == null || result.files.single.path == null) {
                          return; // user cancelled
                        }

                        final originalFile = File(result.files.single.path!);

                        final croppedFile = await ImageCropper().cropImage(
                          sourcePath: originalFile.path,
                          uiSettings: [
                            AndroidUiSettings(
                              toolbarTitle: 'Crop Image',
                              toolbarColor: Colors.black,
                              toolbarWidgetColor: Colors.white,
                              initAspectRatio:
                                  widget.type == 'embed'
                                      ? CropAspectRatioPreset.original
                                      : CropAspectRatioPreset.square,
                              lockAspectRatio: widget.type == 'embed' ? false : true,
                              hideBottomControls: true,
                            ),
                            IOSUiSettings(
                              title: 'Crop Image',
                              aspectRatioLockEnabled: widget.type == 'embed' ? true : false,
                            ),
                          ],
                        );

                        if (croppedFile == null) {
                          // User cancelled cropping
                          return;
                        }

                        final file = File(croppedFile.path);
                        context.read<FileUplBloc>().add(
                          UploadFiles(files: [file], type: widget.type, itemUuid: widget.itemUuid),
                        );
                      } catch (e) {}
                    },
                    child: Svvg.asset('gallery'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _captureImage() async {
    try {
      final CAM.XFile imageFile = await imageCameraController.takePicture();

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: widget.type == 'embed' ? null : CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio:
                widget.type == 'embed'
                    ? CropAspectRatioPreset.original
                    : CropAspectRatioPreset.square,
            lockAspectRatio: widget.type == 'embed' ? false : true,
            hideBottomControls: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: widget.type == 'embed' ? false : true,
            aspectRatioPickerButtonHidden: true,
            rotateButtonsHidden: true,
            resetButtonHidden: true,
          ),
        ],
      );

      if (croppedFile == null) {
        // User cancelled cropping
        return;
      }

      final file = File(croppedFile.path);
      context.read<FileUplBloc>().add(
        UploadFiles(files: [file], type: widget.type, itemUuid: widget.itemUuid),
      );
      Navigator.pop(context);
    } catch (e) {
      // Handle error
      print('Error capturing image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to capture image')));
    }
  }

  PreferredSize scanAppBar(BuildContext context, double rt) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 76 * rt),
      child: SafeArea(
        child: ClipRRect(
          child: Con(
            // h: (56 ),
            // padTop: 17,
            // col: Col.primary.withOpacity(.8),
            padLeft: 10,
            padRight: 10,
            ch: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Cards
                Padd(
                  left: 10,
                  top: 6 * rt,
                  child: Tex(lg.productQR, con: context, col: Colors.black).h22,
                ),
              ],
            ),
          ),
          /*  ), */
        ),
      ),
    );
  }
}
