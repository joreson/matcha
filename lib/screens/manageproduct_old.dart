import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:statemanagement_3a/helpers/dbhelper.dart';
import 'package:statemanagement_3a/models/product.dart';

class ManageProductScreen extends StatefulWidget {
  ManageProductScreen(
      {super.key, this.add, this.update, this.product, this.index});

  final Function(Product p)? add;
  final Function(Product p)? update;

  Product? product;
  int? index;

  @override
  State<ManageProductScreen> createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  var codeController = TextEditingController();

  var nameController = TextEditingController();

  var priceController = TextEditingController();
  var quantityController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    codeController.text = widget.product?.code ?? '';
    nameController.text = widget.product?.nameDesc ?? '';
    priceController.text = widget.product?.price.toString() ?? '';
    quantityController.text = widget.product?.quantity.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // codeController.text = product?.code ?? '';
    // if (product != null) {
    //   codeController.text = product!.code;
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          TextField(
            readOnly: widget.product != null,
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
              var p = Product(
                  code: codeController.text,
                  nameDesc: nameController.text,
                  price: double.parse(priceController.text),
                  quantity: int.parse(quantityController.text));
              if (widget.product == null) {
                widget.add!(p);
              } else {
                widget.update!(p);
              }

              Navigator.of(context).pop();
            },
            child: Text(widget.product == null ? 'ADD' : 'EDIT'),
          )
        ],
      ),
    );
  }
}
