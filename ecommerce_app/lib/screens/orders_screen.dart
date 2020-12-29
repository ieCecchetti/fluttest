import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drower.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

/* the init state serve per non dover sempre mandare la richiesta ad ogni rebuild.
   perchè se cambiasse qualcosa nel mio build si dovrebbe rebuildare tutto e questo farebbe
   rimandare la richiesta. Cosa inutile in questo caso.
 */

class _OrderScreenState extends State<OrderScreen> {
  Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if(dataSnapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          if(dataSnapshot.connectionState == ConnectionState.done)
            return Consumer<Orders>(builder: (ctx, orderData, child) => ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
            ),);
          else{
            //error management
            return Center(child: Text("An error occurred while loading cart"),);
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}

