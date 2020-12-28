import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routename = '/editpscrn';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _desFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFnode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: ' ', price: 0, imageUrl: '');

  var isinit = true;
  var initVal = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  var _isloading = false;

  @override
  void initState() {
    _imageUrlFnode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isinit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findById(productId);
        initVal = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    isinit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFnode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _desFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFnode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFnode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveform() async {
    final isvalid = _form.currentState.validate();
    if (!isvalid) return;
    _form.currentState.save();
    setState(() {
      _isloading = true;
    });
    if (_editedProduct.id == null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Text('OOPS , something went wrong!'),
            title: Text('An error occured!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
      /* finally {
        setState(() {
          _isloading = false;
        });

        Navigator.of(context).pop();
      }*/
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateP(_editedProduct.id, _editedProduct);
      /*setState(() {
        _isloading = false;
      });
      Navigator.of(context).pop();*/
    }
    setState(() {
      _isloading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product '),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveform,
          )
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: initVal['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter some value.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: value,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isfav: _editedProduct.isfav);
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        initialValue: initVal['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_desFocusNode);
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter some value.';
                          }
                          if (double.tryParse(val) == null)
                            return 'Enter some valid value';
                          if (double.parse(val) <= 0) {
                            return 'Enter some valid value';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: double.parse(value),
                              imageUrl: _editedProduct.imageUrl,
                              isfav: _editedProduct.isfav);
                        },
                      ),
                      TextFormField(
                        initialValue: initVal['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _desFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: value,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isfav: _editedProduct.isfav);
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter some description.';
                          }
                          if (val.length < 10) {
                            return 'Description is short';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(right: 10, top: 8),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: _imageUrlController.text.isEmpty
                                  ? Text('Enter a URL')
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                          Expanded(
                            child: TextFormField(
                              //initval                not using as we are using controller here
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFnode,
                              onFieldSubmitted: (_) => _saveform(),
                              onSaved: (value) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: value,
                                    isfav: _editedProduct.isfav);
                              },
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Add an ImageUrl";
                                }
                                if (!val.startsWith("http") &&
                                    !val.startsWith("https")) {
                                  return "Enter a valid Url";
                                }
                                if (!val.endsWith(".jpg") &&
                                    !val.endsWith(".jpeg") &&
                                    !val.endsWith(".png")) {
                                  return "Enter a valid Url";
                                }

                                return null;
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
