import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/ui/android/products_overview/widgets/product.dart';
import '../../../controller/products/products.dart';

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final Products products = Get.put(Products());
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var productId = Get.arguments;
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValue = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (productId != null) {
      _editedProduct = products.findById(productId);
      _initValue = {
        'title': _editedProduct.title,
        'price': _editedProduct.price.toString(),
        'description': _editedProduct.description,
        'imageUrl': '',
      };
      _imageUrlController.text = _editedProduct.imageUrl;
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !!_imageUrlController.text.startsWith('https')) ||
          (!!_imageUrlController.text.endsWith('.jpg') &&
              !!_imageUrlController.text.endsWith('.JPG') &&
              !!_imageUrlController.text.endsWith('.jpeg') &&
              !!_imageUrlController.text.endsWith('.png'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await products.updateProduct(_editedProduct.id, _editedProduct);
      Get.back();
    } else {
      try {
        await products.addProduct(_editedProduct);
        Get.back();
      } catch (error) {
        await Get.dialog<Null>(
          AlertDialog(
            title: Text(
              'An error occurred!',
            ),
            content: Text(
              'Something went wrong.',
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Okay'))
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm,
            )
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        initialValue: _initValue['title'],
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                        onSaved: (value) => _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: value,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl),
                        validator: (value) =>
                            value.isEmpty ? 'Please provide a value' : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        initialValue: _initValue['price'],
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onSaved: (value) => _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value),
                            imageUrl: _editedProduct.imageUrl),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price. ';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number. ';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a numer greater than 0';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        textInputAction: TextInputAction.next,
                        initialValue: _initValue['description'],
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                        onSaved: (value) => _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: value,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description. ';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters long. ';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Image URL',
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) => _saveForm(),
                              onSaved: (value) => _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a URL. ';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL. ';
                                }
                                if (!value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg') &&
                                    !value.endsWith('.png')) {
                                  return 'Please enter a valid image URL. ';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
