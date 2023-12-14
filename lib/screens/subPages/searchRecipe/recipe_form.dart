import 'package:flutter/material.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();

  String recipeName = '';
  String recipeCategory = '';
  int cookTime = 0;
  String difficulty = '';
  String servingSize = '';
  List<Map<String, String>> ingredients = [];
  String selectedIcon =
      '/Users/mecha/Desktop/IT/FLUTTER/shokutomo/shokutomo/assets/img/LOGO.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('レシピを追加'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'レシピ名'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'レシピ名を入力して下さい';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      recipeName = value;
                    });
                  },
                ),
                // DropdownButtonFormField<String>(
                //   value: recipeCategory,
                //   items: [
                //     'ご飯もの',
                //     '麺類',
                //     'おかず',
                //     'スープ',
                //     '寿司',
                //     '焼き物',
                //     '鍋料理',
                //     '揚げ物',
                //     'サラダ',
                //     '甘味',
                //     'おでん',
                //     '粥',
                //     '一品料理',
                //   ].map((category) {
                //     return DropdownMenuItem<String>(
                //       value: category,
                //       child: Text(category),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       recipeCategory = value!;
                //     });
                //   },
                //   decoration: InputDecoration(labelText: 'Recipe Category'),
                // ),
                 TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '出来上がり時間'),
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null) {
                      return 'Por favor, ingresa un número válido';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      cookTime = int.tryParse(value) ?? 0;
                    });
                  },
                ),

                // DropdownButtonFormField<String>(
                //   value: difficulty,
                //   items: ['小', '中', '高'].map((level) {
                //     return DropdownMenuItem<String>(
                //       value: level,
                //       child: Text(level),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       difficulty = value!;
                //     });
                //   },
                //   decoration: InputDecoration(labelText: '難しさ'),
                // ),
                // DropdownButtonFormField<String>(
                //   value: servingSize,
                //   items: ['1', '2~3', '4~5', '5~'].map((size) {
                //     return DropdownMenuItem<String>(
                //       value: size,
                //       child: Text(size),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       servingSize = value!;
                //     });
                //   },
                //   decoration: InputDecoration(labelText: '何人前'),
                // ),
                // Lista de ingredientes
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                ingredients[index]['ingredient'] = value;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: '食材名',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                ingredients[index]['quantity_gram'] = value;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: '個数・グラム',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              ingredients.removeAt(index);
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        ingredients
                            .add({'ingredient_name': '', 'quantity_gram': ''});
                      });
                    },
                    child: const Text('材料追加'),
                  ),
                ),
                // Selección de icono
                ListTile(
                  title: const Text('アイコン'),
                  trailing: GestureDetector(
                    onTap: () {
                      // Implementa la selección del icono
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(selectedIcon),
                    ),
                  ),
                ),

                TextFormField(
                  maxLines: 6,
                  minLines: 6,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: '作り方',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                      borderSide: const BorderSide(
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                      borderSide: const BorderSide(
                        width: 2,
                        // color: Colors.green,
                      ),
                    ),
                  ),
                ),
                // Botones de acción
                Container(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            //!! favorite
                          },
                          icon: const Icon(Icons.favorite),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Acción para guardar
                              // !! save
                            }
                          },
                          icon: const Icon(Icons.save),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
