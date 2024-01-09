import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/recipe_json_map.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();

  Recipe currentRecipe = Recipe(
    recipeName: '',
    recipeNo: '',
    cookTime: 0,
    difficult: '',
    quantity: '',
    recipeCategory: '',
    image: '',
    favoriteStatus: false,
    ingredients: [],
  );

  String recipeNo= '';
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
  List<String> personsGroup = ['1人前', '2~3人前', '4~5人前', '5人前~'];

  int selectedCategory = 0;
  int selectedLevel = 0;
  int selectedPersons = 0;
  int cookTime = 0;

  List<Map<String, String>> ingredients = [];
  String selectedIcon =
      '/Users/mecha/Desktop/IT/FLUTTER/shokutomo/shokutomo/assets/img/LOGO.png';

  bool favoriteStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'レシピを追加',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'レシピ名',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'レシピ名を入力してください';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      currentRecipe.recipeName = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '出来上がり時間'),
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null) {
                      return '正しい数字を入力し下さい';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      currentRecipe.cookTime = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryDropdown(selectedCategory),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildLevelDropdown(selectedLevel),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPersonsDropdown(selectedPersons),
                    ),
                  ],
                ),
                // const SizedBox(height: 10),
                _buildIngredientsList(),
                // const SizedBox(height: 10),
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
                const SizedBox(height: 16),
                ListTile(
                  //!! ICON VALUE /////////////
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          favoriteStatus = !favoriteStatus;
                          currentRecipe.favoriteStatus = favoriteStatus;
                          _formKey.currentState!.save();
                        });
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: favoriteStatus ? Theme.of(context).primaryColor : null,
                      ),
                    ),

                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                    const SizedBox(width: 8),
                    //!!
                    IconButton(
                      onPressed: () {
                        print('save buttoon');
                        if (_formKey.currentState!.validate()) {
                          // Implementa la acción para guardar
                        }
                      },
                      icon: const Icon(Icons.save),
                    ),
                    //!!
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(int selectedCategory) {
    return SizedBox(
      width: double.infinity, // Ocupa todo el ancho disponible
      child: DropdownButton<int>(
        value: selectedCategory,
        isExpanded: true,
        alignment: Alignment.centerLeft,
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
    return SizedBox(
      width: double.infinity, // Ocupa todo el ancho disponible
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
    return SizedBox(
      width: double.infinity, // Ocupa todo el ancho disponible
      child: DropdownButton<int>(
        value: selectedPersons,
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

  Widget _buildIngredientsList() {
    return ListView.builder(
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
              Text(
                category,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<int>> _buildLevelDropdownItems() {
    return levels.map((level) {
      final index = levels.indexOf(level);
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
              Text(
                level,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<int>> _buildPersonsDropdownItems() {
    return personsGroup.map((person) {
      final index = personsGroup.indexOf(person);
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
              Text(
                person,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final Function(bool) onPressed;

  const FavoriteButton(
      {Key? key, required this.isFavorite, required this.onPressed})
      : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        widget.onPressed(!widget.isFavorite);
      },
      icon: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: widget.isFavorite ? Colors.red : null,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.favorite,
          color: widget.isFavorite ? Colors.white : null,
        ),
      ),
    );
  }
}
