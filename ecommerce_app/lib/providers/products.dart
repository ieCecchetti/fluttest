import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  Future<void> fetchAndSetProducts() async{
    const url = "https://flutter-update-d391f-default-rtdb.europe-west1.firebasedatabase.app/products.json";
    var response;
    try{
      response = await http.get(url);
    }catch(error){
      throw error;
    }
    print(json.decode(response.body));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Product> loadedProducts = [];
    if(extractedData != null){
      extractedData.forEach((key, value) {
        loadedProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            isFavourite: value['favourite'],
            imageUrl: value['image']
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    }
  }

  // [...] return copy
  List<Product> items(){
    return [..._items];
  }

  // [...] return copy
  List<Product> favItems(){
    return [..._items].where((element) => element.isFavourite).toList();
  }

  Future<void> addProduct(Product item) async {
    const url = 'https://flutter-update-d391f-default-rtdb.europe-west1.firebasedatabase.app/products.json';
    var response;
    try{
      response= await http.post(url, body: json.encode({
        'title': item.title,
        'description': item.description,
        'image': item.imageUrl,
        'price': item.price,
        'favourite': item.isFavourite,
      }));
    }catch(error){
      print(error);
      return error;
    }

    //print(json.decode(response.body));
    final newProduct =  Product(
      title: item.title,
      description: item.description,
      price: item.price,
      imageUrl: item.imageUrl,
      id: json.decode(response.body)['name'],
    );
    _items.add(item);
    notifyListeners();
  }

  Product findById(String productId){
    return _items.firstWhere((element) => element.id == productId);
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == productId);
    if(prodIndex >= 0){
      final url = 'https://flutter-update-d391f-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json';
      try{
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'image': newProduct.imageUrl,
              'price': newProduct.price
            }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      }catch(error){
        throw error;
      }
    }else{
      print("...");
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url = 'https://flutter-update-d391f-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json';
    final existingProductIndex = _items.indexWhere((element) => element.id == productId);
    var existingProduct = _items[existingProductIndex];

    //optimistic update pattern -> permits rollback!
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400){
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product.");
    }
    existingProduct = null;
  }
}