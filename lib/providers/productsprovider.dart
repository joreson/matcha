import 'package:flutter/material.dart';
import 'package:statemanagement_3a/helpers/dbhelper.dart';
import 'package:statemanagement_3a/models/product.dart';

class Products extends ChangeNotifier {
  List<Product> _items = [];
  List<Product> _items_isfav = [];

  Future<List<Product>> get items async {
    var list = await DbHelper.fetchProducts();
    //Map<String, dynamic> -> Product
    _items = list.map((item) => Product.fromMap(item)).toList();
    return _items;
  }

  Future<List<Product>> get isfavitems async {
    var lists = await DbHelper.fetchfav();
    //Map<String, dynamic> -> Product
    _items_isfav = lists.map((items) => Product.fromMap(items)).toList();
    return _items_isfav;
  }

  int get totalNoItems => _items.length;

  void add(Product p) {
    // _items.add(p);
    DbHelper.insertProduct(p);
    notifyListeners();
  }

  void update(Product p, int index) {
    DbHelper.updateProduct(p);
    notifyListeners();
  }

  void quantity(Product p, int index) {
    print("provider quantity: ${_items[index].quantity}");
    DbHelper.quantityProduct(p);
    notifyListeners();
  }

  void deletecart(Product p, int index) {
    print("provider quantity: ${_items[index].quantity}");
    DbHelper.deleteCart(p);
    notifyListeners();
  }

  void toggleFavorite(int index) {
    _items[index].isFavorite = _items[index].isFavorite;
    notifyListeners();
  }

  Product item(int index) => _items[index];
}
