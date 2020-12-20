import 'package:flutter/material.dart';

import '../widget/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';
  final Function saveFilters;
  final Map<String, bool> currentFilters;

  FiltersScreen(this.currentFilters, this.saveFilters);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutenFree = false;
  var _lactoseFree = false;
  var _vegetarian = false;
  var _vegan = false;

  @override
  initState(){
    _glutenFree = widget.currentFilters['gluten'];
    _lactoseFree = widget.currentFilters['lactose'];
    _vegetarian = widget.currentFilters['vegetarian'];
    _vegan = widget.currentFilters['vegan'];
  }

  Widget _buildSwitchTile(String title, String descr, bool currValue, Function updateFunc){
    return SwitchListTile(
      title: Text(title),
      value: currValue,
      subtitle: Text(descr),
      onChanged: updateFunc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              final selectedFilters = {
                'gluten': _glutenFree,
                'lactose': _lactoseFree,
                'vegetarian': _vegetarian,
                'vegan': _vegan,
              };
              widget.saveFilters(selectedFilters);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
                'Adjust your meal selection.',
                style: Theme.of(context).textTheme.title,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSwitchTile(
                  'Gluten-Free',
                  'Only include gluten-free meals',
                  _glutenFree,
                    (newValue) {
                        setState(() {
                          _glutenFree = newValue;
                        });
                    }
                ),
                _buildSwitchTile(
                    'Lactose-Free',
                    'Only include Lactose-free meals',
                    _lactoseFree,
                        (newValue) {
                      setState(() {
                        _lactoseFree = newValue;
                      });
                    }
                ),
                _buildSwitchTile(
                    'Vegetarian',
                    'Only include vegetarian meals',
                    _vegetarian,
                        (newValue) {
                      setState(() {
                        _vegetarian = newValue;
                      });
                    }
                ),
                _buildSwitchTile(
                    'Vegan',
                    'Only include vegan meals',
                    _vegan,
                        (newValue) {
                      setState(() {
                        _vegan = newValue;
                      });
                    }
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

