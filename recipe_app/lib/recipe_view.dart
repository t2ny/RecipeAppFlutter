import 'package:flutter/material.dart';
import 'package:recipe_app/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipePage extends StatefulWidget {
  const RecipePage(
      {super.key,
      required this.recipeName,
      required this.recipeList,
      required this.index});

  final String recipeName;
  final List<Recipe> recipeList;
  final int index;

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  TextEditingController _txtIngredientCtrl = TextEditingController();
  TextEditingController _txtStepCtrl = TextEditingController();

  void _displayIngredientTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add an ingredient'),
            content: TextField(
              onSubmitted: (value) {
                _addIngredient();
                _saveRecipes();
                Navigator.pop(context);
              },
              controller: _txtIngredientCtrl,
              decoration:
                  const InputDecoration(hintText: "Enter your ingredient name"),
            ),
          );
        });
  }

  void _displayStepTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add a step'),
            content: TextField(
              onSubmitted: (value) {
                _addStep();
                _saveRecipes();
                Navigator.pop(context);
              },
              controller: _txtStepCtrl,
              decoration: const InputDecoration(hintText: "Describe this step"),
            ),
          );
        });
  }

  _saveRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save the recipes
    final String encodedData = Recipe.encode(widget.recipeList);

    await prefs.setString('recipes_key', encodedData);
    setState(() {});
  }

  _addIngredient() {
    widget.recipeList[widget.index].ingredients.add(_txtIngredientCtrl.text);
    _txtIngredientCtrl.clear();
    setState(() {});
  }

  _addStep() {
    widget.recipeList[widget.index].steps.add(_txtStepCtrl.text);
    _txtStepCtrl.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(27.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.recipeName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Ingredients',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 25,
                  width: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      _displayIngredientTextInputDialog(context);
                    },
                    child: Icon(
                      Icons.add,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.recipeList[widget.index].ingredients.length,
              itemBuilder: (context, index) {
                return Text(
                    '- ${widget.recipeList[widget.index].ingredients[index]}');
              },
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Steps',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 25,
                  width: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      _displayStepTextInputDialog(context);
                    },
                    child: Icon(
                      Icons.add,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.recipeList[widget.index].steps.length,
              itemBuilder: (context, index) {
                return Text(
                    'Step ${index + 1}. ${widget.recipeList[widget.index].steps[index]}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
