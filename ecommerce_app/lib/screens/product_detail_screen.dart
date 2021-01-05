import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
        context,
        listen: false,
    ).findById(productId);
    return Scaffold(
      /*appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
       */
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true, // always visible
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              // background is what is visible if the apbar is expanded
              background: Hero(
                tag: loadedProduct.id, // must be same of the on in the productItem
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate([
            SizedBox(height: 10,),
            Text(
              "\$${loadedProduct.price}",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "${loadedProduct.description}",
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            SizedBox(height: 800,)
          ]),
          ),
        ],
      ),
    );
  }
}
