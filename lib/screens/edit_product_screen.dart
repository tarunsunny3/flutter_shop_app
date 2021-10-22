import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  var _editedProduct =
      Product(id: 'null', title: "", price: 0, description: '', imageUrl: '');
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId.toString());

        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    //EditedProduct id is 'null' then it is a NEW PRODUCT
    if (_editedProduct.id == 'null') {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occured!"),
            content: Text('Something went wrong'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Okay"))
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
      ;
    } else {
      //Update the product
      try {
        Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } catch (e) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occured!"),
            content: Text('Something went wrong'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Okay"))
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.blue),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: ListView(children: [
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: InputDecoration(
                      labelText: "Title",
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Please enter the title";
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        id: _editedProduct.id,
                        title: value as String,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['price'],
                    decoration: InputDecoration(labelText: "Price"),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Please enter the price";
                      }
                      if (double.tryParse(value.toString()) == null)
                        return "Please enter a valid number";
                      if (double.parse(value.toString()) <= 0) {
                        return "Please enter a positive number";
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_descFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(value.toString()),
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['description'],
                    decoration: InputDecoration(labelText: "Description"),
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descFocusNode,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Please enter the description";
                      }
                      if (value.toString().length < 10)
                        return "Please enter description of atleast 10 characters";
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: value.toString(),
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    },
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: Container(
                          child: _imageUrlController.text.isEmpty
                              ? Text("Please enter a URL")
                              : FittedBox(
                                  child: Image.network(_imageUrlController.text,
                                      fit: BoxFit.contain),
                                )),
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return "Please enter the image URL";
                          }
                          if (!value.toString().startsWith('http') &&
                              !value.toString().startsWith("https")) {
                            return "Enter a VALID url";
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: "Image URL"),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: value.toString(),
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                    )
                  ]),
                ]),
              ),
            ),
    );
  }
}
