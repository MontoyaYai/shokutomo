import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/product_json_map.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../firebase/productforsearch_json_map.dart';
import '../../firebase/shoplist_json_map.dart';
import 'detector_view.dart';
import 'painters/text_detector_painter.dart';

class TextRecognizerView extends StatefulWidget {
  const TextRecognizerView({Key? key}) : super(key: key);
  @override
  _TextRecognizerViewState createState() => _TextRecognizerViewState();
}

class Pro {
  const Pro({
    required this.name,
    required this.type,
  });
  final String name;
  final String type;
}

var cacheList = [];
List<ShopList> numList = [];

class _TextRecognizerViewState extends State<TextRecognizerView> {
  var _script = TextRecognitionScript.japanese;
  var _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;
  List? testList = [];
  var testProducts = <Pro>[
    const Pro(name: 'プリン', type: 'デザート'),
    const Pro(name: 'ゼリー', type: 'デザート'),
    const Pro(name: 'ケーキ', type: 'デザート'),
    const Pro(name: 'バウムクーヘン', type: 'デザート'),
  ];

  @override
  void initState() {
    super.initState();
    _textRecognizer.close();
    _textRecognizer = TextRecognizer(script: _script);
    final getName = testProducts.map((e) => e.name).toList();
    testList = getName;
    print(getName);
    print('initstart');
    initializeDates();
    print('initend');
  }

  void initializeDates() async {
    List<Product> products = await FirebaseServices().getFirebaseProducts();
    Product product = products[0];
    print(product.productName);
  }

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
    print('disp');
  }

  @override
  Widget build(BuildContext context) {
    print('widg');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'レシート読み取り',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(children: [
        DetectorView(
          title: 'Text Detector',
          customPaint: _customPaint,
          text: _text,
          onImage: _processImage,
          initialCameraLensDirection: _cameraLensDirection,
          onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
        ),
        Positioned(
            top: 30,
            left: 100,
            right: 100,
            child: Row(
              children: [
                Spacer(),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      //child: _buildDropdown(),
                    )),
                Spacer(),
              ],
            )),
      ]),
    );
  }

  /*
  Widget _buildDropdown() => DropdownButton<TextRecognitionScript>(
        value: _script,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.blue),
        underline: Container(
          height: 2,
          color: Colors.blue,
        ),
        onChanged: (TextRecognitionScript? script) {
          if (script != null) {
            setState(() {
              _script = script;
              _textRecognizer.close();
              _textRecognizer = TextRecognizer(script: _script);
            });
          }
        },
        items: TextRecognitionScript.values
            .map<DropdownMenuItem<TextRecognitionScript>>((script) {
          return DropdownMenuItem<TextRecognitionScript>(
            value: script,
            child: Text(script.name),
          );
        }).toList(),
      );
  */
  Future<void> _processImage(InputImage inputImage) async {
    print('proc');
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = TextRecognizerPainter(
        recognizedText,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'Recognized text:\n\n${recognizedText.text}';
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
    list();
    firelist();
  }

  void list() {
    for (var str in testList!) {
      bool contains = _text!.contains(str);
      print('"$_text" \ncontains "$str": $contains');
      if (contains) {
        cacheList.add(str);
      }
    }
    print(cacheList);
  }

  void firelist() async {
    List<Product> products = await FirebaseServices().getFirebaseProducts();
    for (int i = 0; i < products.length; i++) {
      Product product = products[i];
      bool contains = _text!.contains(product.productName);
      if (contains) {
        ShopList num = ShopList(
            productNo: product.productNo,
            name: product.productName,
            quantity: 0,
            gram: 0,
            image: product.image,
            status: 1);
        numList.add(num);
        continue;
      } //else if (contains = _text!.contains(product.hiragana)) {
      //  numList.add([product.productNo, product.productName]);
      //  continue;
      //} else if (contains = _text!.contains(product.katakana)) {
      //  numList.add([product.productNo, product.productName]);
      //  continue;
      //}  else if (contains = _text!.contains(product.kanji) &&  product.kanji != "") {
      // numList.add([product.productNo, product.productName]);
      // continue;
      //}  else if (contains = _text!.contains(product.romaji)) {
      // numList.add([product.productNo, product.productName]);
      // continue;
      //}
    }
    for (int i = 0; i < numList.length; i++) {
      print(numList[i].name);
      print(numList[i].status);
    }
  }

  void _reloadScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => TextRecognizerView()),
    );
  }
}
