//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revup/models/cms_content.dart';
import 'package:revup/services/cms_service.dart';
import 'package:revup/services/license_service.dart';
import 'package:revup/widgets/image_wrapper.dart';

class ImageUploader extends StatefulWidget {
  final List<XFile>? images;
  final String contentName;
  final int maxImages;
  final double height;
  final int columns;

  const ImageUploader({
    Key? key,
    required this.images,
    required this.contentName,
    this.maxImages = 0,
    this.height = 150,
    this.columns = 3,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImageUploaderState();
  }
}

class ImageUploaderState extends State<ImageUploader> {
  @override
  Widget build(BuildContext context) {
    CmsService cmsService = Provider.of<LicenseService>(context).license.cmsService!;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
          width: 1,
        ),
      ),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          _imageAndTextRow(cmsService.getCmsContent(widget.contentName)!),
          ImageWrapper(
            height: widget.height,
            images: widget.images,
            columns: widget.columns,
            removeImage: _removeImage,
          ),
          if (widget.maxImages == 0 || widget.maxImages != widget.images!.length)
            Row(
              children: <Widget>[
                if (!kIsWeb)
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 1,
                            color: Colors.black12,
                          ),
                          right: BorderSide(
                            width: 1,
                            color: Colors.black12,
                          ),
                        ),
                      ),
                      child: SizedBox(
                        height: 30,
                        child: TextButton.icon(
                          onPressed: () {
                            pickImage(ImageSource.camera);
                          },
                          label: const Text('Take Photo'),
                          icon: const Icon(Icons.camera),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: Colors.black12,
                        ),
                      ),
                    ),
                    child: SizedBox(
                      height: 30,
                      child: TextButton.icon(
                        onPressed: () {
                          pickImage(ImageSource.gallery);
                        },
                        label: const Text('Upload Image'),
                        icon: const Icon(Icons.image),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  //
  // Methods
  //
  void pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image == null) return;
    setState(() {
      widget.images!.add(image);
    });
  }

  Widget _imageAndTextRow(CmsContent content) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 100.0,
          child: content.mediaContent,
          ),
          const SizedBox(width: 30),
          Expanded(
            child: content.textContent!,
            /*
            child: RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'need to get from content', //cmsContent[contentName]!.title + '\n',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      height: 3.0,
                    ),
                  ),
                  TextSpan(
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                    text: 'need to get from content', //cmsContent[contentName]!.textContent
                  ),
                ],
              ),
            ),
            */
          ),
        ],
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      widget.images!.removeAt(index);
    });
  }
}
