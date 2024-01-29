import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/get_firebasedata_to_array.dart';
import 'package:shokutomo/firebase/myrecipe_json_map.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  Key circleAvatarKey = GlobalKey();

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
    _loadRecipeNo();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo_sushi.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text(
              'レシピ追加',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/fondo_up.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextFormField(
                    labelText: 'レシピ名',
                    onChanged: (value) {
                      setState(() {
                        currentRecipe.recipeName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    labelText: '出来上がり時間',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        currentRecipe.cookTime = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownRow(
                    _buildCategoryDropdown(selectedCategory),
                    _buildLevelDropdown(selectedLevel),
                    _buildPersonsDropdown(selectedPersons),
                  ),
                  const SizedBox(height: 16),
                  _buildIngredientsList(),
                  const SizedBox(height: 16),
                  _buildAddIngredientButton(),
                  const SizedBox(height: 16),
                  _buildImagePicker(),
                  const SizedBox(height: 16),
                  _buildMultilineTextFormField(
                    labelText: '作り方',
                    onChanged: (value) {
                      setState(() {
                        currentRecipe.howTo = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String) onChanged,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.white70,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelTextを入力してください';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }

  Widget _buildMultilineTextFormField({
    required String labelText,
    required void Function(String) onChanged,
  }) {
    return TextFormField(
      maxLines: 6,
      minLines: 6,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
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
        filled: true,
        fillColor: Colors.white70,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownRow(
    Widget categoryDropdown,
    Widget levelDropdown,
    Widget personsDropdown,
  ) {
    return Row(
      children: [
        Expanded(child: categoryDropdown),
        const SizedBox(width: 8),
        Expanded(child: levelDropdown),
        const SizedBox(width: 8),
        Expanded(child: personsDropdown),
      ],
    );
  }

  Widget _buildCategoryDropdown(int selectedCategory) {
    return _buildDropdown<int>(
      value: selectedCategory,
      items: _buildCategoryDropdownItems(),
      onChanged: (value) {
        setState(() {
          this.selectedCategory = value!;
          currentRecipe.recipeCategory = recipeCategory[this.selectedCategory];
        });
      },
    );
  }

  Widget _buildLevelDropdown(int selectedLevel) {
    return _buildDropdown<int>(
      value: selectedLevel,
      items: _buildLevelDropdownItems(),
      onChanged: (value) {
        setState(() {
          this.selectedLevel = value!;
          currentRecipe.difficult = levels[this.selectedLevel];
        });
      },
    );
  }

  Widget _buildPersonsDropdown(int selectedPersons) {
    return _buildDropdown<int>(
      value: selectedPersons,
      items: _buildPersonsDropdownItems(),
      onChanged: (value) {
        setState(() {
          this.selectedPersons = value!;
          currentRecipe.quantity = personsGroup[this.selectedPersons];
        });
      },
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        items: items,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 2,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> _buildCategoryDropdownItems() {
    return recipeCategory.map((category) {
      final index = recipeCategory.indexOf(category);
      return DropdownMenuItem<int>(
        value: index,
        child: _buildDropdownItem(category),
      );
    }).toList();
  }

  List<DropdownMenuItem<int>> _buildLevelDropdownItems() {
    return levels.map((level) {
      final index = levels.indexOf(level);
      return DropdownMenuItem<int>(
        value: index,
        child: _buildDropdownItem(level),
      );
    }).toList();
  }

  List<DropdownMenuItem<int>> _buildPersonsDropdownItems() {
    return personsGroup.map((person) {
      final index = personsGroup.indexOf(person);
      return DropdownMenuItem<int>(
        value: index,
        child: _buildDropdownItem(person),
      );
    }).toList();
  }

  Widget _buildDropdownItem(String text) {
    return Container(
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
            text,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 8), // Ajusta el espacio vertical según tus preferencias
          child: Row(
            children: [
              Expanded(
                child: _buildTextFormField(
                  labelText: '食材名',
                  onChanged: (value) {
                    setState(() {
                      if (ingredients.length > index) {
                        ingredients[index].ingredientName = value;
                        if (currentRecipe.ingredients.length > index) {
                          currentRecipe.ingredients[index].ingredientName =
                              value;
                        }
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextFormField(
                  labelText: '個数・グラム',
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
          ),
        );
      },
    );
  }

  Widget _buildAddIngredientButton() {
    return Center(
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
    );
  }

  Widget _buildImagePicker() {
    return ListTile(
      title: const Text('アイコン'),
      trailing: GestureDetector(
        onTap: _pickImage,
        child: CircleAvatar(
          key: circleAvatarKey,
          radius: 20,
          backgroundImage: imagePath.isNotEmpty
              ? FileImage(File(imagePath)) as ImageProvider<Object>?
              : AssetImage(selectedIcon),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
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
        IconButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await firebaseServices.addOrUpdateMyRecipe(currentRecipe);
              // ignore: use_build_context_synchronously
              Navigator.pop(context, true);
            }
          },
          icon: const Icon(Icons.save),
        ),
      ],
    );
  }

  Future<String?> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageName =
          'user_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final appDir = await getApplicationDocumentsDirectory();
      final newImage =
          await File(pickedFile.path).copy('${appDir.path}/$imageName');
      imagePath = newImage.path;

      setState(() {
        currentRecipe.image = imagePath;
        circleAvatarKey = GlobalKey();
      });

      return imagePath;
    }
    return null;
  }
}
