import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:statemanagement_3a/models/product.dart';
import 'package:statemanagement_3a/providers/productsprovider.dart';

class ManageProductScreen extends StatefulWidget {
  ManageProductScreen({
    super.key,
    this.index,
  });

  int? index;

  @override
  State<ManageProductScreen> createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  var codeController = TextEditingController();

  var nameController = TextEditingController();

  var priceController = TextEditingController();

  var quantityController = TextEditingController();
  void alert() {
    AlertDialog(
      title: const Text('AlertDialog Title'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('This is a demo alert dialog.'),
            Text('Would you like to approve of this message?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Approve'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // codeController.text = widget.product?.code ?? '';
    // nameController.text = widget.product?.nameDesc ?? '';
    // priceController.text = widget.product?.price.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<Products>(context);
    Product? product;

    if (widget.index != null) {
      product = productProvider.item(widget.index!);
    }
    codeController.text = product?.code ?? '';
    nameController.text = product?.nameDesc ?? '';
    priceController.text = product?.price.toString() ?? '';
    bool isProductFavorite = product?.isFavorite ?? false;
    bool isProductCart = product?.isCart ?? false;
    int quantitys = product?.quantity ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index == null ? 'Add Product' : 'Edit Product'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          TextField(
            readOnly: widget.index != null,
            controller: codeController,
            decoration: const InputDecoration(
                label: Text('Code'), border: OutlineInputBorder()),
          ),
          const Gap(8),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
                label: Text('Name/Desc'), border: OutlineInputBorder()),
          ),
          const Gap(8),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(
                label: Text('Price'), border: OutlineInputBorder()),
          ),
          ElevatedButton(
            onPressed: () {
              // Validate if any field is empty
              if (codeController.text.isEmpty ||
                  nameController.text.isEmpty ||
                  priceController.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Please enter values for all fields.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else if (!RegExp(r'^[0-9]+(?:\.[0-9]+)?$')
                  .hasMatch(priceController.text)) {
                // Validate if price is not a valid number
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content:
                          Text('Please enter a valid number for the price.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else if (widget.index == null) {
                // If all validations pass and it's a new entry, add the product
                var p = Product(
                  code: codeController.text,
                  nameDesc: nameController.text,
                  price: double.parse(priceController.text),
                  isFavorite: isProductFavorite,
                  isCart: isProductCart,
                  quantity: quantitys,
                );
                productProvider.add(p);
                Navigator.of(context).pop();
              } else {
                // If all validations pass and it's an edit, update the product
                var p = Product(
                  code: codeController.text,
                  nameDesc: nameController.text,
                  price: double.parse(priceController.text),
                  isFavorite: isProductFavorite,
                  isCart: isProductCart,
                  quantity: quantitys,
                );
                productProvider.update(p, widget.index!);
                Navigator.of(context).pop();
              }
            },
            child: Text(widget.index == null ? 'ADD' : 'EDIT'),
          )
        ],
      ),
    );
  }
}
