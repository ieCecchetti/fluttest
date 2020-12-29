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
  var _isInit = true;
  var _isLoading = false;


  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WONT WORK
    // Future.delayed(Duration.zero).then((_) => {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // }); // THIS TAKES SOME TIME AND IS AN HACK
    super.initState();
  }


  @override
  void didChangeDependencies() {
    if(_isInit){
      _isLoading = true;
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator(),)
          : ProductsGrid(_showFavourite),
    );
  }


}
