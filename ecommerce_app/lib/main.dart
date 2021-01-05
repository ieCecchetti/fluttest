import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

import './helpers/custom_route.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //ChangeNotifierProvider.value when we want to instantiate a list and add stuff
    //ChangeNotifierProvider when we want to use a single entry
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth(),),
        //for a provider that depends on another one ..PROXY
        ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items()
            ),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart(),),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousProducts) => Orders(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            // per un page transition personalizzato (per piattaforma o per tutto)
            /*pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              }

             */
            )
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : FutureBuilder(
              future: auth.tryAutologging(),
              builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                  ? SplashScreen()
                  : AuthScreen(),
          ),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        )

      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),
      body: ProductsOverviewScreen(),
    );
  }
}
