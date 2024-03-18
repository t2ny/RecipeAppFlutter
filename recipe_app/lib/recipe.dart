import 'dart:convert';

class Recipe {
  final String recipeName;
  final List<String> ingredients;
  final List<String> steps;

  Recipe(
      {required this.recipeName,
      required this.ingredients,
      required this.steps});

  factory Recipe.fromJson(Map<String, dynamic> jsonData) {
    return Recipe(
        recipeName: jsonData['recipeName'],
        ingredients: (jsonData['ingredients'] as List<dynamic>).cast<String>(),
        steps: (jsonData['steps'] as List<dynamic>).cast<String>());
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeName': recipeName,
      'ingredients': ingredients,
      'steps': steps
    };
  }

  static Map<String, dynamic> toMap(Recipe recipe) => {
        'recipeName': recipe.recipeName,
        'ingredients': recipe.ingredients,
        'steps': recipe.steps
      };

  static String encode(List<Recipe> recipes) => json.encode(
        recipes
            .map<Map<String, dynamic>>((recipe) => Recipe.toMap(recipe))
            .toList(),
      );

  static List<Recipe> decode(String recipes) =>
      (json.decode(recipes) as List<dynamic>)
          .map<Recipe>((item) => Recipe.fromJson(item))
          .toList();
}
