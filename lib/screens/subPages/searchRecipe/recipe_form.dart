import 'package:flutter/material.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();

  String recipeName = '';

  List<String> recipeCategory = [
    'ご飯もの',
    '麺類',
    'おかず',
    'スープ',
    '寿司',
    '焼き物',
    '鍋料理',
    '揚げ物',
    'サラダ',
    '甘味',
    'おでん',
    '粥',
    '一品料理',
  ];
  List<String> levels = ['小', '中', '高'];
  List <String> personsGroup =['1人前', '2~3人前', '4~5人前', '5人前~'];

  int selectedCategory = 0;
  int selectedLevel = 0;
  int selectedPersons =0;

  int cookTime = 0;

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
        padding: const EdgeInsets.all(32.0),
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
                      return 'レシピ名を入力してください';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      recipeName = value;
                    });
                  },
                ),
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
                const SizedBox(height: 15),
               Row(
                children: [
                  Expanded(
                    child: _buildCategoryDropdown(selectedCategory),
                  ),
                  const SizedBox(width: 16), // Agrega un espacio entre los Dropdowns
                  Expanded(
                    child: _buildLevelDropdown(selectedLevel),
                  ),
                   Expanded(
                    child: _buildPersonsDropdown(selectedPersons),
                  ),
                ],
              ),
                // const SizedBox(height: 5),
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
                        ingredients.add({'ingredient_name': '', 'quantity_gram': ''});
                      });
                    },
                    child: const Text('材料追加'),
                  ),
                ),
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
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Implementa la acción para marcar como favorito
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
                              // Implementa la acción para guardar
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

  Widget _buildCategoryDropdown(int selectedCategory) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<int>(
        value: selectedCategory,
        isExpanded: true,
        items: _buildDropdownItems(),
        onChanged: (value) {
          setState(() {
            selectedCategory = value!;
          });
        },
      ),
    );
  }

  Widget _buildLevelDropdown(int selectedLevel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<int>(
        value: selectedLevel,
        isExpanded: true,
        items: _buildLevelDropdownItems(),
        onChanged: (value) {
          setState(() {
            selectedLevel = value!;
          });
        },
      ),
    );
  }

  Widget _buildPersonsDropdown(int selectedPersons) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<int>(
        value: selectedLevel,
        isExpanded: true,
        items: _buildPersonsDropdownItems(),
        onChanged: (value) {
          setState(() {
            selectedPersons = value!;
          });
        },
      ),
    );
  }

  List<DropdownMenuItem<int>> _buildDropdownItems() {
    return recipeCategory.map((category) {
      final index = recipeCategory.indexOf(category);
      return DropdownMenuItem<int>(
        value: index,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 25,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // color: colo,r
                ),
              ),
              Text(category),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<int>> _buildLevelDropdownItems() {
    return levels.map((level) {
    final index =levels.indexOf(level);
      return DropdownMenuItem<int>(
        value: index,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 25,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // color: colo,r
                ),
              ),
              Text(level),
            ],
          ),
        ),
      );
    }).toList();
  }
  
  List<DropdownMenuItem<int>> _buildPersonsDropdownItems() {
    return personsGroup.map((person) {
    final index =personsGroup.indexOf(person);
      return DropdownMenuItem<int>(
        value: index,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 25,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // color: colo,r
                ),
              ),
              Text(person),
            ],
          ),
        ),
      );
    }).toList();
  }
}
