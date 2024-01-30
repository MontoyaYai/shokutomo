import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shokutomo/text_recognition/vision_detector_views/confirm_dialog_text.dart';

import '../../firebase/product_json_map.dart';
import 'text_detector_view.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({
    super.key,
    this.text,
    required this.onImage,
    required this.onDetectorViewModeChanged,
  });

  final String? text;
  final Function(InputImage inputImage) onImage;
  final Function()? onDetectorViewModeChanged;

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  File? _image;
  ImagePicker? _imagePicker;

  List<Product> product = [];

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  
   void removeProduct(int index) {
    setState(() {
      print('Removing product at index: $index');
      productsList.removeAt(index);
    });
  }

  Future<void> fetchTextList() async {
    setState(() {});
  }

  String getList() {
    return productsList.map((product) => product.name).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/fondo_up_down.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: 0,
              onDestinationSelected: (int index) {
                if (index == 0) {
                  _getImage(ImageSource.gallery);
                } else if (index == 1) {
                  _getImage(ImageSource.camera);
                } else if (index == 2) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return InsertTextItemsConfirm(onUpdate: fetchTextList);
                    },
                  );
                }
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.image_search_outlined),
                  selectedIcon: Icon(Icons.image_search),
                  label: Text('メディア'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.camera_alt),
                  selectedIcon: Icon(Icons.camera),
                  label: Text('カメラ'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add),
                  selectedIcon: Icon(Icons.add),
                  label: Text('在庫追加'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
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
                        : Image.asset('assets/img/text_nolistentry.png'),
                    const SizedBox(height: 16),
                    if (productsList.isNotEmpty)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: productsList.map((product) {
                          return ElevatedButton(
                            onPressed: null,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor.withOpacity(
                                      0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                                const SizedBox(
                                    width:
                                        8), 
                                InkWell(
                                  onTap: () {
                                  int currentIndex = productsList.indexOf(product);
                                      print('Clicked on button at index: $currentIndex');
                                      removeProduct(currentIndex);
                                    // Lógica al hacer clic en la "x"
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    else
                      Image.asset('assets/img/nolistentry.png'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      await _processFile(pickedFile.path);
    }
  }

  Future _processFile(String path) async {
    setState(() {
      _image = File(path);
    });
    final inputImage = InputImage.fromFilePath(path);
    widget.onImage(inputImage);
  }
}
