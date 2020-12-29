import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartItem{
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price
  });
}

class Cart with ChangeNotifier{
  Map<String, CartItem> _item = {};

  Map<String, CartItem> get items {
    return{..._item};
  }

  Future<void> addItem(String productId, double price, String title) async {
    final url = 'https://flutter-update-d391f-default-rtdb.europe-west1.firebasedatabase.app/cart.json';
    try{
      if(_item.containsKey(productId)){
        CartItem inserted = _item.update(productId,
                (value) => CartItem(
              id: value.title,
              title: value.title,
              price: value.price,
              quantity: value.quantity+1,
            )
        );
        await http.patch(url, body: json.encode({
          'id': inserted.id,
          'title': inserted.title,
          'price': inserted.price,
          'quantity': inserted.quantity+1,
        }));
      }else{
        CartItem inserted = _item.putIfAbsent(productId,
                () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1,
            )
        );
        await http.post(url, body: json.encode({
          'id': inserted.id,
          'title': inserted.title,
          'price': inserted.price,
          'quantity': inserted.quantity+1,
        }));
      }
      notifyListeners();
    }catch(error){
      throw error;
    }

  }

  int get itemCount{
    return _item.length;
  }

  double get totAmount{
    double total = 0.0;
    _item.forEach((key, value) {
      total += (value.quantity*value.price);
    });
    return total;
  }

  void removeItem(String id){
    _item.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id){
    if(_item.containsKey(id)){
      if(_item[id].quantity>1)
        _item.update(id, (value) => CartItem(
          id: value.id,
          title: value.title,
          quantity: value.quantity-1,
          price: value.price,
        ));
      else{
        _item.remove(id);
      }
      notifyListeners();
    }
    return;
  }

  void clearCart(){
    _item = {};
    notifyListeners();
  }

}