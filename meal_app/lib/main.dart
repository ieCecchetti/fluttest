import 'package:flutter/material.dart';

import './dummy_data.dart';
import './models/meal.dart';
import './screen/filters_screen.dart';
import './screen/tabs_screen.dart';
import './screen/categories_screen.dart';
import './screen/category_meals_screen.dart';
import './screen/meal_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegetarian': false,
    'vegan': false,
  };
  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favouritedMeals = [];

  void _setFilters(Map<String, bool> newFilters){
    setState(() {
      _filters = newFilters;

      _availableMeals = DUMMY_MEALS.where((element) {
        if((element.isGlutenFree == _filters['gluten']) &&
          (element.isLactoseFree == _filters['lactose']) &&
          (element.isVegetarian == _filters['vegetarian']) &&
          (element.isVegan == _filters['vegan']))
          return true;
        else
          return false;
      }).toList();
    });
  }

  void _toggleFavourite(String mealId){
    final existingIndex = _favouritedMeals.indexWhere((element) => element.id == mealId);
    if (existingIndex >= 0){
      setState(() {
        _favouritedMeals.removeAt(existingIndex);
      });
    }else{
      setState(() {
        _favouritedMeals.add(DUMMY_MEALS.firstWhere((element) => element.id == mealId));
      });
    }
  }

  bool _isMealFavourite(String id){
    //any is like exists
    return _favouritedMeals.any((element) => element.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Meals',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.amber,
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
              body1: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1)
              ),
              body2: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1)
              ),
              title: TextStyle(
                  fontSize: 20,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold
              )
          )
      ),
      //home: CategoriesScreen(),
      initialRoute: '/',
      routes: {
        '/': (ctx) => TabScreen(_favouritedMeals),
        CategoryMealScreen.routeName: (ctx) => CategoryMealScreen(_availableMeals),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen(_toggleFavourite, _isMealFavourite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters, _setFilters),
      },
      // go here if a new route is taken that is not in routeMap
      onGenerateRoute: (settings) {
        print(settings.arguments);
        //permits to create very dynamic routes
//        if (settings.name == 'meal-detail/case1')
//          return ...;
//        else if(settings.name == 'meal-detail/case2')
//          return ...;
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen(),);
      },
      //if we didnt define any route and there is not defined the onGenerateRoute
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen(),);
      },
    );
  }
}

