import 'package:ecommerce_app/models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false
  });

  Future<void> toggleFavouriteStatus() async {
    final url = 'https://flutter-update-d391f-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json';
    try{
      isFavourite = !isFavourite;
      notifyListeners();
      var response = await http.patch(url, body: json.encode({
        'favourite': this.isFavourite
      }));
      if (response.statusCode >=400)
        throw HttpException("error in update the preference");
    }catch(error){
      isFavourite = !isFavourite;
      notifyListeners();
      throw error;
    }
  }
}