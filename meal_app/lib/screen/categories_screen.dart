import 'package:flutter/material.dart';

import '../widget/category_item.dart';
import '../dummy_data.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView(
        padding: const EdgeInsets.all(25),
        children: DUMMY_CATEGORIES
            .map((e) => CategoryItem(
            e.id,
            e.title,
            e.color)
        ).toList(),
        //SliverGridDelegateWithMaxCrossAxisExtent given the width it auto
        //resize the GridView to enter them
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3/2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
    ),
    );
  }
}
