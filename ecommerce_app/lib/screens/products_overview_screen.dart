import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../widgets/product_grid.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/app_drower.dart';

enum FilterOption {
  Favourite,
  All,
}

  class ProductsOverviewScreen extends StatefulWidget {
    @override
    _ProductsOverviewScreen createState()  => _ProductsOverviewScreen();
  }

  class _ProductsOverviewScreen extends State<ProductsOverviewScreen>{
  var _showFavourite = false;
  @override
  Widget build(BuildContext context) {
    final productContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if(selectedValue == FilterOption.Favourite){
                  _showFavourite = true;
                }else{
                  _showFavourite = false;
                }
              });
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(child: Text("Only Favourite"), value: FilterOption.Favourite,),
              PopupMenuItem(child: Text("Sow All"), value: FilterOption.All,),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                  Icons.shopping_cart
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showFavourite),
    );
  }


}
