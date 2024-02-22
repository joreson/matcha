import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statemanagement_3a/helpers/dbhelper.dart';
import 'package:statemanagement_3a/models/cartitem.dart';
import 'package:statemanagement_3a/models/product.dart';
import 'package:statemanagement_3a/providers/cartprovider.dart';
import 'package:statemanagement_3a/providers/productsprovider.dart';
import 'package:statemanagement_3a/screens/manageproduct.dart';
import 'package:statemanagement_3a/screens/viewcart.dart';
import 'package:flutter/services.dart';

class ViewProductsScreen extends StatefulWidget {
  @override
  State<ViewProductsScreen> createState() => _ViewProductsScreenState();
}

class _ViewProductsScreenState extends State<ViewProductsScreen> {
  bool favorite = false;

  void openAddScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ManageProductScreen(),
      ),
    );
  }

  void openEditScreen(BuildContext context, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ManageProductScreen(index: index),
      ),
    );
  }

  void addToCart(BuildContext context, String pCode) {}

  @override
  Widget build(BuildContext context) {
    var prodProvider = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Products'),
        actions: [
          IconButton(
            onPressed: () => openAddScreen(context),
            icon: Icon(Icons.add),
          ),
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Text("All"),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text("Favorite Only"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              setState(() {
                favorite = false;
              });
            } else if (value == 1) {
              setState(() {
                favorite = true;
              });
            }
          }),
        ],
      ),
      body: Consumer<Products>(
        builder: (_, products, _c) {
          return FutureBuilder(
            future: products.items,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var productList = snapshot.data;
              print(productList);
              print(favorite);

              return ListView.builder(
                itemBuilder: (_, index) => favorite &&
                        productList![index].isFavorite
                    ? Card(
                        child: ListTile(
                          onTap: () => openEditScreen(context, index),
                          leading: IconButton(
                            onPressed: () {
                              if (productList![index].isFavorite) {
                                var p = Product(
                                  code: productList[index].code,
                                  nameDesc: productList[index].nameDesc,
                                  price: double.parse(
                                      productList[index].price.toString()),
                                  quantity: productList[index].quantity,
                                  isFavorite: false,
                                );
                                prodProvider.update(p, index);
                              } else {
                                var p = Product(
                                  code: productList[index].code,
                                  nameDesc: productList[index].nameDesc,
                                  price: double.parse(
                                      productList[index].price.toString()),
                                  quantity: productList[index].quantity,
                                  isFavorite: true,
                                );
                                prodProvider.update(p, index);
                              }
                            },
                            icon: Icon(productList![index].isFavorite
                                ? Icons.favorite
                                : Icons.favorite_outline),
                          ),
                          title: Text(productList[index].nameDesc),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                prodProvider.quantity(
                                    productList[index], index);
                              });
                            },
                            icon: Icon(Icons.shopping_cart_outlined),
                          ),
                        ),
                      )
                    : !favorite
                        ? Card(
                            child: ListTile(
                              onTap: () => openEditScreen(context, index),
                              leading: IconButton(
                                onPressed: () {
                                  if (productList![index].isFavorite) {
                                    var p = Product(
                                        code: productList[index].code,
                                        nameDesc: productList[index].nameDesc,
                                        price: double.parse(productList[index]
                                            .price
                                            .toString()),
                                        quantity: productList[index].quantity,
                                        isFavorite: false);
                                    prodProvider.update(p, index);
                                  } else {
                                    var p = Product(
                                        code: productList[index].code,
                                        nameDesc: productList[index].nameDesc,
                                        quantity: productList[index].quantity,
                                        price: double.parse(productList[index]
                                            .price
                                            .toString()),
                                        isFavorite: true);
                                    prodProvider.update(p, index);
                                  }
                                },
                                icon: Icon(productList![index].isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_outline),
                              ),
                              title: Text(productList[index].nameDesc),
                              trailing: IconButton(
                                onPressed: () {
                                  prodProvider.quantity(
                                      productList[index], index);
                                },
                                icon: Icon(Icons.shopping_cart_outlined),
                              ),
                            ),
                          )
                        : const Card(),
                itemCount: products.totalNoItems,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ViewCartScreen(),
          ),
        ),
        child: Icon(Icons.shopping_cart_checkout),
      ),
    );
  }
}
