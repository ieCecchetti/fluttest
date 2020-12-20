import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widget/meal-item.dart';

class CategoryMealScreen extends StatefulWidget {
  static const routeName = '/category-meals';
  final List<Meal> availableMeals;

  CategoryMealScreen(this.availableMeals);

  @override
  _CategoryMealScreenState createState() => _CategoryMealScreenState();
}

class _CategoryMealScreenState extends State<CategoryMealScreen>{
  String categoryTitle;
  List<Meal> displayedMeals;
  var _loadedInitData = false;

  //here not work the context.. i cant do anything
  @override
  void initState() {
    super.initState();
  }

  //to change stuff when popping
  @override
  void didChangeDependencies() {
    if (!_loadedInitData){
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
      final String id = routeArgs['id'];
      categoryTitle = routeArgs['title'];
      //get the receipt correspondant with the category we select
      displayedMeals = widget.availableMeals.where((element) {
        return element.categories.contains(id);
      }).toList();
      _loadedInitData = true;
    }

    super.didChangeDependencies();
  }

  void _removeMeal(String mealId){
    setState(() {
      displayedMeals.removeWhere((element) => element.id == mealId);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.builder(itemBuilder: (ctx, index) {
        return MealItem(
          id: displayedMeals[index].id,
          title: displayedMeals[index].title,
          imageUrl: displayedMeals[index].imageUrl,
          duration: displayedMeals[index].duration,
          complexity: displayedMeals[index].complexity,
          affordability: displayedMeals[index].affordability,
          removeItem: null,
        );
      }, itemCount: displayedMeals.length,),
    );
  }
}
