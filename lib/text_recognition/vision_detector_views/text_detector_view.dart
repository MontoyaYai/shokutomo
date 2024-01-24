import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/get_firebasedata_to_array.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';
import 'package:shokutomo/firebase/product_json_map.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'detector_view.dart';
import 'painters/text_detector_painter.dart';

class TextRecognizerView extends StatefulWidget {
  const TextRecognizerView({Key? key}) : super(key: key);
  @override
  _TextRecognizerViewState createState() => _TextRecognizerViewState();
}

List<MyProducts> productsList = [];

class _TextRecognizerViewState extends State<TextRecognizerView> {
  var _script = TextRecognitionScript.japanese;
  var _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;

  @override
  void initState() {
    super.initState();
    _textRecognizer.close();
    _textRecognizer = TextRecognizer(script: _script);
    initializeDates();
  }

  void initializeDates() async {
    List<Product> products = await GetFirebaseDataToArray().products;
    Product product = products[0];
    print(product.productName);
  }

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('widg');
    setState(() {});
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
          customPaint: _customPaint,
          text: _text,
          onImage: _processImage,
          initialCameraLensDirection: _cameraLensDirection,
          onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
        ),
      ]),
    );
  }

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
    addProductsList();
    print(_text);
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  void addProductsList() async {
    List<Product> products = await GetFirebaseDataToArray().products;
    List<String> lines = _text!.split('\n');
    for (String text in lines) {
      for (int i = 0; i < products.length; i++) {
        Product product = products[i];
        bool contains = text.contains(product.productName);
        if (contains) {
          // 既存の商品のインデックスを確認
          int existingIndex = productsList.indexWhere(
              (existingProduct) => existingProduct.name == product.productName);
          if (existingIndex != -1) {
            // 同じ名前の商品が存在する場合は数量を増やす
            productsList[existingIndex].quantity += 1;
          } else {
            // 同じ名前の商品が存在しない場合は新しい商品を追加
            DateTime useByDate =
                DateTime.now().add(Duration(days: product.categoryUseBy));
            DateTime exDate = DateTime(
              useByDate.year,
              useByDate.month,
              useByDate.day,
            );
            MyProducts addproduct = MyProducts(
              no: product.productNo,
              name: product.productName,
              quantity: 1,
              gram: 0,
              image: product.image,
              purchasedDate: DateTime.now(),
              expiredDate: exDate,
            );
            productsList.add(addproduct);
          }
        }
      }
      for (int i = 0; i < productsList.length; i++) {
        print(productsList[i].name);
      }
      setState(() {});
    }
  }
}
