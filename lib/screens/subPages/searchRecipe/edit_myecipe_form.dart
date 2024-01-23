import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/get_firebasedata_to_array.dart';
import 'package:shokutomo/firebase/myrecipe_json_map.dart';

class EditMyRecipeForm extends StatefulWidget {
  final MyRecipe recipe;
  const EditMyRecipeForm({super.key, required this.recipe});

  @override
  EditMyRecipeFormState createState() => EditMyRecipeFormState();
}

class EditMyRecipeFormState extends State<EditMyRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();

  MyRecipe currentRecipe = MyRecipe(
    recipeName: '',
    recipeNo: '',
    howTo: '',
    cookTime: 0,
    difficult: '',
    quantity: '',
    recipeCategory: '',
    image: '',
    favoriteStatus: false,
    ingredients: [],
  );

  FirebaseServices firebaseServices = FirebaseServices();

  String imagePath = '';
  String recipeNo = '';
  String recipeName = '';
  String howTo = '';

  List<String> recipeCategory = [
    'カテゴリ',
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
  List<String> levels = ['難易度', '小', '中', '高'];
  List<String> personsGroup = ['人分', '1人前', '2~3人前', '4~5人前', '5人前~'];

  List<Ingredient> ingredients = [];

  int selectedCategory = 0;
  int selectedLevel = 0;
  int selectedPersons = 0;
  int cookTime = 0;

  String selectedIcon = 'assets/img/galery.png';

  bool favoriteStatus = false;

  @override
  void initState() {
    super.initState();
    currentRecipe = widget.recipe;
    _loadRecipeNo();
    recipeName = currentRecipe.recipeName;
    cookTime = currentRecipe.cookTime;
    selectedCategory = recipeCategory.indexOf(currentRecipe.recipeCategory);
    selectedLevel = levels.indexOf(currentRecipe.difficult);
    selectedPersons = personsGroup.indexOf(currentRecipe.quantity);
    ingredients = [];
    for (var ingredient in currentRecipe.ingredients) {
      ingredients.add(Ingredient(
        ingredientName: ingredient.ingredientName,
        quantityGram: ingredient.quantityGram,
      ));
    }
    favoriteStatus = currentRecipe.favoriteStatus;
    howTo = currentRecipe.howTo;
    imagePath = currentRecipe.image;
  }

  Future<void> _loadRecipeNo() async {
    final allRecipes = await GetFirebaseDataToArray().myRecipesArray();
    final maxRecipeNo = allRecipes.isNotEmpty
        ? allRecipes
            .map((recipe) => int.tryParse(recipe.recipeNo) ?? 0)
            .reduce((value, element) => value > element ? value : element)
        : 0;
    final newRecipeNo = (maxRecipeNo + 1).toString();
    setState(() {
      recipeNo = newRecipeNo;
      currentRecipe.recipeNo = newRecipeNo;
      print("actual $recipeNo");
    });
  }

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
                  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                  initialValue: recipeName,
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
                  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                  initialValue: cookTime.toString(),
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
                _buildIngredientsList(),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final newIngredient =
                            Ingredient(ingredientName: '', quantityGram: '');
                        ingredients.add(newIngredient);
                        currentRecipe.ingredients.add(newIngredient);
                      });
                    },
                    child: const Text('材料追加'),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('アイコン'),
                  trailing: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: imagePath.isNotEmpty
                          ? Image.file(File(imagePath)).image
                          : Image.asset(selectedIcon).image,
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
                  initialValue: howTo,
                  onChanged: (value) {
                    setState(() {
                      currentRecipe.howTo = value;
                    });
                  },
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
                        color: favoriteStatus
                            ? Theme.of(context).primaryColor
                            : null,
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
                    IconButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          print(currentRecipe.toMap());
                          await firebaseServices
                              .addOrUpdateMyRecipe(currentRecipe);
                          Navigator.pop(context, true);
                        }
                      },
                      icon: const Icon(Icons.save),
                    ),
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
      width: double.infinity,
      child: DropdownButton<int>(
        value: selectedCategory,
        isExpanded: true,
        alignment: Alignment.centerLeft,
        items: _buildCategoryDropdownItems(),
        onChanged: (value) {
          setState(() {
            this.selectedCategory = value!;
            currentRecipe.recipeCategory =
                recipeCategory[this.selectedCategory];
          });
        },
      ),
    );
  }

  Widget _buildLevelDropdown(int selectedLevel) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButton<int>(
        value: selectedLevel,
        isExpanded: true,
        items: _buildLevelDropdownItems(),
        onChanged: (value) {
          setState(() {
            this.selectedLevel = value!;
            currentRecipe.difficult = levels[this.selectedLevel];
          });
        },
      ),
    );
  }

  Widget _buildPersonsDropdown(int selectedPersons) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButton<int>(
        value: selectedPersons,
        isExpanded: true,
        items: _buildPersonsDropdownItems(),
        onChanged: (value) {
          setState(() {
            this.selectedPersons = value!;
            currentRecipe.quantity = personsGroup[this.selectedPersons];
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
                    if (ingredients.length > index) {
                      ingredients[index].ingredientName = value;
                      if (currentRecipe.ingredients.length > index) {
                        currentRecipe.ingredients[index].ingredientName = value;
                      }
                    }
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
                    if (ingredients.length > index) {
                      ingredients[index].quantityGram = value;
                      if (currentRecipe.ingredients.length > index) {
                        currentRecipe.ingredients[index].quantityGram = value;
                      }
                    }
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
                  if (ingredients.length > index) {
                    ingredients.removeAt(index);
                    if (currentRecipe.ingredients.length > index) {
                      currentRecipe.ingredients.removeAt(index);
                    }
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  List<DropdownMenuItem<int>> _buildCategoryDropdownItems() {
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
                ),
              ),
              Text(
                level,
                style: const TextStyle(fontSize: 13),
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
                ),
              ),
              Text(
                person,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Future<String?> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageName =
          'user_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final appDir = await getApplicationDocumentsDirectory();
      final newImage =
          await File(pickedFile.path).copy('${appDir.path}/$imageName');
      final imagePath = newImage.path;
      print('Ruta de la imagen: $imagePath');
      setState(() {
        currentRecipe.image =
            imagePath; // Almacena la ruta completa en el campo image
      });
      return imagePath;
    }
    return null;
  }
}