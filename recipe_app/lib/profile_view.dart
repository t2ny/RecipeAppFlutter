import 'package:flutter/material.dart';
import 'package:recipe_app/recipe.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.recipeList});

  final List<Recipe> recipeList;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _getIngredientCount() {
    int count = 0;
    widget.recipeList.forEach((element) {
      count += element.ingredients.length;
    });

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 85,
                  width: 85,
                  margin: const EdgeInsets.only(right: 20.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                  ),
                ),
                const Text(
                  'Welcome,\nto your profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 80,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.recipeList.length} Recipes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    '${_getIngredientCount()} Ingredients',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
