import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widget/main_drawer.dart';
import './favourite_screen.dart';
import './categories_screen.dart';

class TabScreen extends StatefulWidget {
  final List<Meal> favouriteMeals;

  TabScreen(this.favouriteMeals);

  @override
  _TabScreenState createState() => _TabScreenState();
}

//tabs down
class _TabScreenState extends State<TabScreen> {
  List<Map<String,Object>> _tabs;

  int _selectedTabIndex = 0;

  @override
  void initState() {
    _tabs = [
      {'page':CategoriesScreen(), 'title':'Categories', /*'actions':[FlatButton]*/},
      {'page':FavouriteScreen(widget.favouriteMeals), 'title':'Your Favourite'},
    ];

    super.initState();
  }

  void _onSelectTab(int index){
    setState(() {
      _selectedTabIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text(_tabs[_selectedTabIndex]['title']),
          ),
        body: _tabs[_selectedTabIndex]['page'],
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.white,
          selectedItemColor: Theme.of(context).accentColor,
          backgroundColor: Theme.of(context).primaryColor,
          currentIndex: _selectedTabIndex,
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.category),
                title: Text('Categories')
            ),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.star),
                title: Text('Favourite')
            ),
          ],
          onTap: _onSelectTab,
        ),
      );
  }
}

//tabs up
/*
class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
//      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Meals'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.category), text: 'Categories',),
              Tab(icon: Icon(Icons.star), text: 'Favourite',),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CategoriesScreen(),
            FavouriteScreen(),
          ],
        ),
      ),
    );
  }
}
*/