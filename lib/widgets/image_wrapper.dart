//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageWrapper extends StatelessWidget {
  final List<XFile>? images;
  final int columns;
  final double height;
  final double runSpacing;
  final double spacing;
  final WrapAlignment alignment;
  final ValueSetter<int>? removeImage;

  const ImageWrapper({
    Key? key,
    required this.images,
    this.columns = 1,
    this.height = 150,
    this.runSpacing = 4,
    this.spacing = 4,
    this.removeImage,
    this.alignment = WrapAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return images == null
        ? const SizedBox.shrink()
        : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final width = (constraints.maxWidth - runSpacing * (columns - 1)) / columns;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  runSpacing: runSpacing,
                  spacing: spacing,
                  alignment: alignment,
                  children: List.generate(images!.length, (index) => _wrappedImage(index, width)),
                ),
              );
            },
          );
  }

  Widget _wrappedImage(int index, double width) {
    return Stack(
      children: <Widget>[
        Container(
          height: height,
          width: width,
          padding: const EdgeInsets.only(bottom: 6),
          child: FutureBuilder(
            future: images![index].readAsBytes(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Image.memory(
                  snapshot.data,
                  fit: BoxFit.contain,
                );
              } else if (snapshot.hasError) {
                return const Text('Image decode error');
              } else {
                return const Text('Loading...');
              }
            },
          ),
        ),
        if (removeImage != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: Transform.scale(
              scale: 0.4,
              child: FloatingActionButton(
                child: const Icon(Icons.clear),
                onPressed: () => removeImage!(index),
              ),
            ),
          ),
      ],
    );
  }
}
