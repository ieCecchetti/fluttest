import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

import './cart.dart';

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    final url = 'https://flutter-update-d391f-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    var response;
    try{
      response = await http.post(url, body: json.encode({
        'amount': total,
        'products': cartProducts.map((e) => {
          'id': e.id,
          'title': e.title,
          'quantity': e.quantity,
          'price': e.price
        }).toList(),
        'dateTime': timestamp.toIso8601String(),
      }));
    }catch(error){
      throw error;
    }
    _orders.insert(0, OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now()
    ));
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://flutter-update-d391f-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    var response;
    try{
      response = await http.get(url);
    }catch(error){
      throw error;
    }

    final List<OrderItem> loadedOrders = [];
    print(json.decode(response.body));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData != null){
      extractedData.forEach((key, value) {
        loadedOrders.add(OrderItem(
            id: value['id'],
            amount: value['amount'],
            dateTime: DateTime.parse(value['dateTime']),
            products: (value['products'] as List<dynamic>).map(
                    (e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price']
                )).toList()
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    }

  }

}