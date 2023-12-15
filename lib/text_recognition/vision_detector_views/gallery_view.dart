import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shokutomo/text_recognition/vision_detector_views/confirm_dialog_text.dart';

import '../../firebase/product_json_map.dart';
import 'text_detector_view.dart';

class GalleryView extends StatefulWidget {
  GalleryView(
      {Key? key,
      this.text,
      required this.onImage,
      required this.onDetectorViewModeChanged})
      : super(key: key);

  final String? text;
  final Function(InputImage inputImage) onImage;
  final Function()? onDetectorViewModeChanged;

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  File? _image;
  //String? _path;
  ImagePicker? _imagePicker;

  List<Product> product = [];

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();
  }

  Future<void> fetchTextList() async {
    setState(() {});
  }

  void update() {
    setState(() {});
    Widget.canUpdate;
  }

  String getList() {
    return productsList.map((product) => product.name).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _galleryBody());
  }

  Widget _galleryBody() {
    return ListView(shrinkWrap: true, children: [
      _image != null
          ? SizedBox(
              height: 400,
              width: 400,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.file(_image!),
                ],
              ),
            )
          : const Icon(
              Icons.image,
              size: 200,
            ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
            child: const Text('From Gallery'),
            onPressed: () {
              _getImage(ImageSource.gallery);
              setState(() {});
            }),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
            child: const Text('Take a picture'),
            onPressed: () {
              _getImage(ImageSource.camera);
              setState(() {});
            }),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
            child: const Text('在庫に追加'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return InsertTextItemsConfirm(onUpdate: fetchTextList);
                  });
              setState(() {});
            }),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: productsList.isNotEmpty
            ? Text(
                getList(),
                style: TextStyle(fontSize: 18),
              )
            : Text(
                'リストにまだアイテムがありません',
                style: TextStyle(fontSize: 20),
              ),
      ),
      /*if (_image != null)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
              '${_path == null ? '' : 'Image path: $_path'}\n\n${widget.text ?? ''}'),
        ),
      */
    ]);
  }

  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      //_path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      await _processFile(pickedFile.path);
      setState(() {});
    }
  }

  Future _processFile(String path) async {
    setState(() {
      _image = File(path);
    });
    //_path = path;
    final inputImage = InputImage.fromFilePath(path);
    widget.onImage(inputImage);
  }
}
