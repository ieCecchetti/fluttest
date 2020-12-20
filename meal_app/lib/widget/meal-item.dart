import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../screen/meal_detail_screen.dart';

class MealItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  final Function removeItem;

  MealItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.duration,
    @required this.complexity,
    @required this.affordability,
    @required this.removeItem,
  });

  String get complexityToText{
    switch(complexity){
      case Complexity.Simple:
        return 'Simple';
      case Complexity.Intermediate:
        return 'Intermediate';
      case Complexity.Hard:
        return 'Hard';
      default:
        return 'N.D.';
    }
  }

  String get affordabilityToText{
    switch(affordability){
      case Affordability.Affordable:
        return 'Affordable';
      case Affordability.Pricey:
        return 'Pricey';
      case Affordability.Luxurious:
        return 'Expensive';
      default:
        return 'N.D.';
    }
  }

  void selectMeal(BuildContext ctx){
    Navigator.of(ctx).pushNamed(
        MealDetailScreen.routeName,
        arguments: id
    )
        .then((result) {
      if(result != null){
        removeItem(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectMeal(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                //force circular widget
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    width: 250,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.white
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(children: [
                    Icon(Icons.schedule,),
                    SizedBox(width: 6,),
                    Text('$duration min'),
                  ],),
                  Row(children: [
                    Icon(Icons.work,),
                    SizedBox(width: 6,),
                    Text(complexityToText),
                  ],),
                  Row(children: [
                    Icon(Icons.work,),
                    SizedBox(width: 6,),
                    Text(affordabilityToText),
                  ],),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
