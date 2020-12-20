import 'package:flutter/material.dart';

import '../screen/filters_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function handler){
    return ListTile(
      leading: Icon(icon, size: 26,),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondesed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: handler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          //heading
          Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Text(
              'Cooking Up!',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(height: 20,),
          buildListTile(
              'Meal',
              Icons.restaurant,
              () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
          buildListTile(
              'Filters',
              Icons.settings,
              () {
                Navigator.of(context).pushReplacementNamed(FiltersScreen.routeName);
              }),
          //elements
        ],
      ),
    );
  }
}
