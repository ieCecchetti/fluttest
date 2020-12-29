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
    var cart = Provider.of<Cart>(context);
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
                  OrderButton(cart: cart,),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text("ORDER NOW"),
      onPressed: widget.cart.totAmount <= 0 || _isLoading ? null : () async {
        setState(() {
          _isLoading = true;
        });
        try{
          await Provider.of<Orders>(context, listen: false).addOrders(
              widget.cart.items.values.toList(),
              widget.cart.totAmount
          );
          widget.cart.clearCart();
        }catch(error){
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Some error occurred. Please retry."),
              duration: Duration(seconds: 2),
            ),);
        }
        setState(() {
          _isLoading = false;
        });
      },
      textColor: Theme.of(context).primaryColor,
    );
  }
}


