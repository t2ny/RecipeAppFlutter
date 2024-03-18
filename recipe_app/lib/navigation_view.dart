import 'package:flutter/material.dart';
import 'package:recipe_app/ai_view.dart';
import 'package:recipe_app/home.dart';
import 'package:recipe_app/login.dart';
import 'package:recipe_app/profile_view.dart';
import 'package:recipe_app/recipe.dart';
import 'package:recipe_app/search.dart';
import 'package:recipe_app/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  var _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  List<Recipe> recipeList = [];

  @override
  void initState() {
    super.initState();
    debugPrint('Navigation View Loaded');
    _loadRecipes();
  }

  _loadRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Load the recipes
    final String? recipeString = prefs.getString('recipes_key');

    if (recipeString == null) {
      return;
    }

    recipeList = Recipe.decode(recipeString);

    debugPrint(recipeList[0].ingredients[0]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Recipe Vault'),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomePage(recipeList: recipeList),
          SearchPage(recipes: recipeList),
          AIPage(),
          ProfilePage(recipeList: recipeList),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology),
              label: 'A.I.',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
          onTap: (index) {
            if (index == 4) {
              // If the logout button is pressed
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginApp()),
                (route) => false, // remove all previous routes
              );
            } else {
              _pageController.jumpToPage(index);
            }
          }),
    );
  }
}
