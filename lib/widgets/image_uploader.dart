import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revup/models/cms_content.dart';
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
  Map<String, CmsContent> cmsContent = {};

  @override
  Widget build(BuildContext context) {
    cmsContent = Provider.of<Map<String, CmsContent>>(context);
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
          _imageAndTextRow(widget.contentName),
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

  Widget _imageAndTextRow(String contentName) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
            cmsContent[contentName]!.mediaContent,
            width: 100,
          ),
          const SizedBox(width: 30),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: cmsContent[contentName]!.title + '\n',
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      height: 3.0,
                    ),
                  ),
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                    text: cmsContent[contentName]!.textContent
                  ),
                ],
              ),
            ),
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
