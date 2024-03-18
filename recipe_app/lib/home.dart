import 'package:flutter/material.dart';
import 'package:recipe_app/recipe.dart';
import 'package:recipe_app/recipe_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.recipeList});

  final List<Recipe> recipeList;
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _txtController = TextEditingController();

  _saveRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save the recipes
    Recipe recipe =
        Recipe(recipeName: _txtController.text, ingredients: [], steps: []);

    widget.recipeList.add(recipe);

    final String encodedData = Recipe.encode(widget.recipeList);

    await prefs.setString('recipes_key', encodedData);
    _txtController.clear();
    setState(() {});
  }

  _delete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = Recipe.encode(widget.recipeList);
    await prefs.setString('recipes_key', encodedData);
    setState(() {});
  }

  void _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add a recipe'),
            content: TextField(
              onSubmitted: (value) {
                _saveRecipes();
                Navigator.pop(context);
              },
              controller: _txtController,
              decoration:
                  const InputDecoration(hintText: "Enter your recipe name"),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: ListView(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 15.0, top: 20.0),
              child: CircleAvatar(
                radius: 67,
                backgroundColor: Colors.black,
                child: CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'My Recipes',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.recipeList.length,
              itemBuilder: (context, index) {
                return RecipeCard(
                  recipeName: widget.recipeList[index].recipeName,
                  recipeList: widget.recipeList,
                  index: index,
                  callback: _delete,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context);
        },
        tooltip: 'Add a recipe',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildFoodCategoryCard(
      {required String imageUrl, required String categoryName}) {
    return SizedBox(
      width: 300,
      height: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                imageUrl,
                width: 300,
                height: 150,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeCard extends StatefulWidget {
  const RecipeCard(
      {super.key,
      required this.recipeName,
      required this.recipeList,
      required this.index,
      required this.callback});

  final String recipeName;
  final List<Recipe> recipeList;
  final int index;
  final Function callback;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 20.0, right: 16.0, bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.recipeName),
              SizedBox(
                width: 40,
                height: 20,
                child: ElevatedButton(
                  onPressed: () {
                    widget.recipeList.removeWhere(
                        (recipe) => recipe.recipeName == widget.recipeName);
                    widget.callback();
                  },
                  child: const Icon(
                    Icons.delete,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        debugPrint(widget.index.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecipePage(
                      recipeName: widget.recipeName,
                      recipeList: widget.recipeList,
                      index: widget.index,
                    )));
      },
    );
  }
}
