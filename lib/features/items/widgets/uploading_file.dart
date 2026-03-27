import 'dart:io';

import 'package:flutter/material.dart';

import '../../../config/failure.dart';

class UploadingImageCard extends StatelessWidget {
  const UploadingImageCard({
    super.key,
    required this.file,
    this.value,
    this.failure,
    this.onRemoveTap,
    this.onRetryTap,
  });

  final File file;
  final double? value;
  final Failure? failure;
  final void Function()? onRemoveTap;
  final void Function()? onRetryTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFA1A1A1).withOpacity(0.5), width: 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Center(child: Image.file(file, fit: BoxFit.cover, height: 100, width: 100)),
              GestureDetector(
                onTap: onRemoveTap,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.cancel, color: Color(0xFFF3F3F3)),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child:
                    (value != null)
                        ? SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(value: value),
                        )
                        : failure != null
                        ? GestureDetector(
                          onTap: onRetryTap,
                          child: Icon(Icons.refresh, color: Colors.red),
                        )
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
