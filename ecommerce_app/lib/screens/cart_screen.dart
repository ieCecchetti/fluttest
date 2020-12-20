import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// im just interested in Cart class here
import '../providers/cart.dart' show Cart;
// I put an alias for the class
import '../widgets/cart_item.dart' as ci;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total", style: TextStyle(fontSize: 20),),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.title.color
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text("ORDER NOW"),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrders(
                          cart.items.values.toList(),
                          cart.totAmount
                      );
                      cart.clearCart();
                    },
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            )
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => ci.CartItem(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].title,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].price
              ),
            ),
          )
        ],
      ),
    );
  }
}
