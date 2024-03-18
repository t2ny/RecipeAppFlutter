import 'package:flutter/material.dart';
import 'package:recipe_app/home.dart';
import 'package:recipe_app/recipe.dart';
import 'package:recipe_app/recipe_view.dart';
import 'package:get/get.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.recipes});
  final List<Recipe> recipes;

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  late List<Recipe> filteredRecipes = [];

  void filterRecipes(String search) {
    setState(() {
      filteredRecipes = widget.recipes
          .where(
              (e) => e.recipeName.toLowerCase().contains(search.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                      TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          filterRecipes(value);
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(width: 0.5),
                          ),
                          hintText: 'Search Recipes...',
                          prefixIcon: const Icon(Icons.search, size: 25.0),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ListView.builder(
                          itemCount: filteredRecipes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(filteredRecipes[index].recipeName),
                              shape: CircleBorder(),
                              onTap: () {
                                int selectedRecipeIndex = index;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipePage(
                                        recipeName: filteredRecipes[index].recipeName,
                                        recipeList: filteredRecipes,
                                        index: selectedRecipeIndex),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ])))));
  }
}
