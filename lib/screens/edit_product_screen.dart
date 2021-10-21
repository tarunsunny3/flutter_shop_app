import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          child: ListView(children: [
            TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                }),
            TextFormField(
                decoration: InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descFocusNode);
                }),
            TextFormField(
              decoration: InputDecoration(labelText: "Description"),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              focusNode: _descFocusNode,
            ),
            Row(children: [
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(top: 8, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Container(child: _imageUrlController.text.isEmpty ? Text("Please enter a URL") : FittedBox(child: Image.network(_imageUrlController.text, fit: BoxFit.cover))),
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Image URL"),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  controller: _imageUrlController,
                ),
              )
            ]),
          ]),
        ),
      ),
    );
  }
}
