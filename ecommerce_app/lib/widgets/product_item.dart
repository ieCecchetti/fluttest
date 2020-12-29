import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    // provider MUST be placed at lowest level possible
    final product = Provider.of<Product>(context, listen: false,);
    final cart = Provider.of<Cart>(context, listen: false,);
    // use Consumer instead of Provider.of<Product> for reload just some part of the app..
    // some widget only
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (context, product, child) => IconButton(
                icon: Icon(product.isFavourite ? Icons.favorite : Icons.favorite_border),
                onPressed: () async {
                  try{
                    await product.toggleFavouriteStatus();
                  }catch(error){
                    Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Some error occurred while updating the preference."),
                          duration: Duration(seconds: 2),
                          ),);
                  }
                },
                color: Colors.deepOrange,
              ),
              //child: Text("Never change!"), an object that never change dynamically
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                try{
                  cart.addItem(product.id, product.price, product.title);
                }catch(error){
                  Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Some error accured."),
                        duration: Duration(seconds: 2),
                      ));
                }
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Added item to cart."),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: "UNDO",
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                    ));
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
    );
  }
}
