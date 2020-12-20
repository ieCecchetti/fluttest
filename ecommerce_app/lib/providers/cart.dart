import 'package:flutter/foundation.dart';

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

  void addItem(String productId, double price, String title){
    if(_item.containsKey(productId)){
      _item.update(productId,
              (value) => CartItem(
                id: value.title,
                title: value.title,
                price: value.price,
                quantity: value.quantity+1,
              )
      );
    }else{
      _item.putIfAbsent(productId,
              () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              )
      );
    }
    notifyListeners();
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