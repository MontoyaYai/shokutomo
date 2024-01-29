import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/myrecipe_json_map.dart';
import 'package:shokutomo/screens/subPages/searchRecipe/my_recipe_detail_page.dart';

class EditMyRecipeForm extends StatefulWidget {
  final MyRecipe recipe;
  const EditMyRecipeForm({super.key, required this.recipe});

  @override
  EditMyRecipeFormState createState() => EditMyRecipeFormState();
}

class EditMyRecipeFormState extends State<EditMyRecipeForm> {
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

    currentRecipe = widget.recipe;
    recipeNo = currentRecipe.recipeNo;
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

  ImageProvider<Object> _getImageProvider() {
    if (imagePath.isNotEmpty) {
      // Si hay una imagen seleccionada, mostrarla
      return FileImage(File(imagePath));
    } else {
      // Si no hay imagen seleccionada, mostrar la imagen predeterminada
      return AssetImage(selectedIcon);
    }
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
              width: 30, // ajusta el ancho según sea necesario
              height: 30, // ajusta la altura según sea necesario
            ),
            const SizedBox(width: 8), // Espacio entre la imagen y el texto
            const Text(
              'レシピを編集',
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
            image: AssetImage('assets/img/fondo_up_down.png'),
            fit: BoxFit.fill,
          ),
        ),
        
        child: Padding(
        
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
            
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const SizedBox(height: 16),
                  _buildTextFormField(
                    labelText: 'レシピ名',
                    initialValue: recipeName,
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
                    initialValue: cookTime.toString(),
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
                        key: circleAvatarKey,
                        radius: 20,
                        backgroundImage: _getImageProvider(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMultilineTextFormField(
                  labelText: '作り方',
                    initialValue: widget.recipe.howTo,
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
                            // print(currentRecipe.toMap());
                            await firebaseServices
                                .addOrUpdateMyRecipe(currentRecipe);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context); // Cierra la pantalla actual
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailPage(recipe: currentRecipe),
                              ),
                            );
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
      ),
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
        // final ingredientNameController = TextEditingController(
        //   text: ingredients[index].ingredientName,
        // );
        final quantityGramController = TextEditingController(
          text: ingredients[index].quantityGram,
        );

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _buildTextFormField(
                labelText: '食材名',
                  // controller: ingredientNameController,
                  initialValue:ingredients[index].ingredientName,
                  onChanged: (value) {
                    setState(() {
                      ingredients[index] = Ingredient(
                        ingredientName: value,
                        quantityGram: ingredients[index].quantityGram,
                      );
                      currentRecipe.ingredients = List.from(ingredients);
                    });
                  },
                  // decoration: const InputDecoration(
                  //   labelText: '食材名',
                  // ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextFormField(
                  // controller: quantityGramController,
                  labelText: '個数・グラム',
                  initialValue: ingredients[index].quantityGram,
                  onChanged: (value) {
                    setState(() {
                      ingredients[index] = Ingredient(
                        ingredientName: ingredients[index].ingredientName,
                        quantityGram: value,
                      );
                      currentRecipe.ingredients = List.from(ingredients);
                    });
                  },
                  // decoration: const InputDecoration(
                  //   labelText: '個数・グラム',
                  // ),
                ),
              ),
                    const SizedBox(height: 16),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (ingredients.length > index) {
                      ingredients.removeAt(index);
                      currentRecipe.ingredients = List.from(ingredients);
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
  Widget _buildMultilineTextFormField({
    required String labelText,
    required void Function(String) onChanged, required String initialValue,
  }) {
    return TextFormField(
    initialValue: howTo,
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

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageName =
          'user_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final appDir = await getApplicationDocumentsDirectory();
      final newImage =
          await File(pickedFile.path).copy('${appDir.path}/$imageName');
      final newImagePath = newImage.path;

      setState(() {
        currentRecipe.image = newImagePath;
        imagePath = newImagePath; // Actualiza la variable imagePath
      });

      circleAvatarKey = GlobalKey(); // Reconstruye el CircleAvatar
    }
  }
   Widget _buildTextFormField({
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String) onChanged, required String initialValue,
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
      initialValue: initialValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelTextを入力してください';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
