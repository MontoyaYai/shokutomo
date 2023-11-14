import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';
import 'package:shokutomo/firebase/product_json_map.dart';

class CreateRecordDialog extends StatefulWidget {
  final String productName;

  const CreateRecordDialog({Key? key, required this.productName})
      : super(key: key);

  @override
  _CreateRecordDialogState createState() => _CreateRecordDialogState();
}

class _CreateRecordDialogState extends State<CreateRecordDialog> {
  DateTime selectedDate = DateTime.now(); // Initialize with the current date
  late DateTime useByDate; // Initialize the variable
  late DateTime selectedUseByDate; // Initialize the variable
  bool isChangeableExpiredDate = true;

  late int grams = 0;
  late String name;
  late int quantity = 0;

  @override
  void initState() {
    super.initState();
    initializeDates();
  }

  void initializeDates() async {
    List<Product> products = await FirebaseServices().getFirebaseProducts();
    Product selectedProduct = products.firstWhere(
      (product) => product.productName == widget.productName,
    );
    setState(() {
      useByDate =
          DateTime.now().add(Duration(days: selectedProduct.categoryUseBy));
      selectedUseByDate = useByDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: FirebaseServices().getFirebaseProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = snapshot.data!.cast<Product>();
          Product selectedProduct = products.firstWhere(
            (product) => product.productName == widget.productName,
          );

          useByDate =
              DateTime.now().add(Duration(days: selectedProduct.categoryUseBy));

          return AlertDialog(
            title: Text(selectedProduct.productName),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset(
                        "assets/img/${selectedProduct.image}",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    '購入日',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<int>(
                          value: selectedDate.year,
                          onChanged: (int? newValue) {
                            setState(() {
                              if (newValue != null) {
                                DateTime changedValue = DateTime(
                                  newValue,
                                  selectedDate.month,
                                  selectedDate.day,
                                );
                                // もし賞味期限日は購入日より前だったら、注意メッセージが出る
                                if (changedValue.isAfter(selectedUseByDate)) {
                                  isChangeableExpiredDate = false;
                                } else {
                                  isChangeableExpiredDate = true;
                                  selectedDate = changedValue;
                                }
                              }
                            });
                          },
                          items: List<DropdownMenuItem<int>>.generate(
                            10,
                            (int index) {
                              final int year = DateTime.now().year + index;
                              return DropdownMenuItem<int>(
                                value: year,
                                child: Text(year.toString()),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: DropdownButton<int>(
                          value: selectedDate.month,
                          onChanged: (int? newValue) {
                            setState(() {
                              if (newValue != null) {
                                DateTime changedValue = DateTime(
                                  selectedDate.year,
                                  newValue,
                                  selectedDate.day,
                                );
                                // もし賞味期限日は購入日より前だったら、注意メッセージが出る
                                if (changedValue.isAfter(selectedUseByDate)) {
                                  isChangeableExpiredDate = false;
                                } else {
                                  isChangeableExpiredDate = true;
                                  selectedDate = changedValue;
                                }
                              }
                            });
                          },
                          items: List<DropdownMenuItem<int>>.generate(
                            12,
                            (int index) {
                              return DropdownMenuItem<int>(
                                value: index + 1,
                                child: Text((index + 1).toString()),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: DropdownButton<int>(
                          value: selectedDate.day,
                          onChanged: (int? newValue) {
                            setState(() {
                              if (newValue != null) {
                                DateTime changedValue = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  newValue,
                                );
                                // もし賞味期限日は購入日より前だったら、注意メッセージが出る
                                if (changedValue.isAfter(selectedUseByDate)) {
                                  isChangeableExpiredDate = false;
                                } else {
                                  isChangeableExpiredDate = true;
                                  selectedDate = changedValue;
                                }
                              }
                            });
                          },
                          items: List<DropdownMenuItem<int>>.generate(
                            31,
                            (int index) {
                              return DropdownMenuItem<int>(
                                value: index + 1,
                                child: Text((index + 1).toString()),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    '消費・賞味期限日',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<int>(
                          value: selectedUseByDate.year,
                          onChanged: (int? newValue) {
                            setState(() {
                              if (newValue != null) {
                                DateTime changedValue = DateTime(
                                  newValue,
                                  selectedUseByDate.month,
                                  selectedUseByDate.day,
                                );
                                // もし賞味期限日は購入日より前だったら、注意メッセージが出る
                                if (selectedDate.isAfter(changedValue)) {
                                  isChangeableExpiredDate = false;
                                } else {
                                  isChangeableExpiredDate = true;
                                  selectedUseByDate = changedValue;
                                }
                              }
                            });
                          },
                          items: List<DropdownMenuItem<int>>.generate(
                            10,
                            (int index) {
                              final int year = DateTime.now().year - 1 + index;
                              return DropdownMenuItem<int>(
                                value: year,
                                child: Text(year.toString()),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: DropdownButton<int>(
                          value: selectedUseByDate.month,
                          onChanged: (int? newValue) {
                            setState(() {
                              if (newValue != null) {
                                DateTime changedValue = DateTime(
                                  selectedUseByDate.year,
                                  newValue,
                                  selectedUseByDate.day,
                                );
                                // もし賞味期限日は購入日より前だったら、注意メッセージが出る
                                if (selectedDate.isAfter(changedValue)) {
                                  isChangeableExpiredDate = false;
                                } else {
                                  isChangeableExpiredDate = true;
                                  selectedUseByDate = changedValue;
                                }
                              }
                            });
                          },
                          items: List<DropdownMenuItem<int>>.generate(
                            12,
                            (int index) {
                              return DropdownMenuItem<int>(
                                value: index + 1,
                                child: Text((index + 1).toString()),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: DropdownButton<int>(
                          value: selectedUseByDate.day,
                          onChanged: (int? newValue) {
                            setState(() {
                              if (newValue != null) {
                                DateTime changedValue = DateTime(
                                  selectedUseByDate.year,
                                  selectedUseByDate.month,
                                  newValue,
                                );
                                // もし賞味期限日は購入日より前だったら、注意メッセージが出る
                                if (selectedDate.isAfter(changedValue)) {
                                  isChangeableExpiredDate = false;
                                } else {
                                  isChangeableExpiredDate = true;
                                  selectedUseByDate = changedValue;
                                }
                              }
                            });
                          },
                          items: List<DropdownMenuItem<int>>.generate(
                            31,
                            (int index) {
                              return DropdownMenuItem<int>(
                                value: index + 1,
                                child: Text((index + 1).toString()),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!isChangeableExpiredDate)
                    const Text(
                      "購入日より前の賞味期限を設定することが出来ません！",
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: '個数',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      setState(() {
                        quantity = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'グラム',
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      setState(() {
                        grams = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () async {
                  DateTime purchaseDate = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                  );
                  DateTime expiredDay = DateTime(
                    selectedUseByDate.year,
                    selectedUseByDate.month,
                    selectedUseByDate.day,
                  );
                  //!!
                  Product selectedProduct = products.firstWhere(
                    (product) => product.productName == widget.productName,
                  );
                  print(selectedProduct);
                  final myProduct = MyProducts(
                    no: selectedProduct.productNo,
                    name: selectedProduct.productName,
                    image: selectedProduct.image,
                    quantity: quantity,
                    gram: grams,
                    purchasedDate: purchaseDate,
                    expiredDate: expiredDay,
                  );

                  // Utiliza el nuevo método para agregar o actualizar el producto en Firebase
                  await FirebaseServices()
                      .addOrUpdateFirebaseMyProduct(myProduct);

                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('保存'),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: const Text('エラー'),
            content: const Text('エラー発生しています'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('オッケ'),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
