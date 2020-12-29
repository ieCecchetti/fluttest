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
  // actual focused input
  final _printFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(id: null, title: "", price: 0, description: "", imageUrl: "");
  var _isInit = true;
  var _isLoading = false;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    //remember to dispose them or will go to memory leak
    _printFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //add listener for image changes
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }


  @override
  void didChangeDependencies() {
    if (_isInit){
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null){
        _editedProduct = Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //'imageUrl': _editedProduct.imageUrl,
          'imageUrl': _editedProduct.imageUrl,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl(){
    if (!_imageUrlFocusNode.hasFocus){
      if (_imageUrlController.text.isEmpty
          || (!_imageUrlController.text.startsWith("http")
            && !_imageUrlController.text.startsWith("https"))
          || (!_imageUrlController.text.endsWith(".png")
          && !_imageUrlController.text.endsWith(".jpg")
          && !_imageUrlController.text.endsWith(".jpeg")))
        return;

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    if (!_form.currentState.validate())
      return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if(_editedProduct.id != null){
      try{
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      }catch(error){
        await showDialog(context: context,
            builder: (ctx) => AlertDialog(
              title: Text("An error occurred!"),
              content: Text("Something went wrong!"),
              actions: [
                FlatButton(onPressed: () {
                  Navigator.of(ctx).pop();
                }, child: Text("Ok"))
              ],
            ));
      }
    }
    else{
      try{
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      }catch (error){
        await showDialog(context: context,
            builder: (ctx) => AlertDialog(
              title: Text("An error occurred!"),
              content: Text("Something went wrong!"),
              actions: [
                FlatButton(onPressed: () {
                  Navigator.of(ctx).pop();
                }, child: Text("Ok"))
              ],
            ));
      }
    }
    setState(() {
      _isLoading = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          //autovalidate: true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _initValues['title'],
                  decoration: InputDecoration(labelText: "Title",),
                  //last key on the right of the corner go to next formField
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_printFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty)
                      return "Please provide a value.";
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = new Product(
                        id: _editedProduct.id,
                        title: value,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        isFavourite: _editedProduct.isFavourite,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValues['price'],
                  decoration: InputDecoration(labelText: "Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _printFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty)
                      return "Please enter a price.";
                    if (double.tryParse(value) == null)
                      return "Please enter a valid number.";
                    if (double.parse(value) <= 0)
                      return "Please enter a number > 0.";
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = new Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(value),
                        imageUrl: _editedProduct.imageUrl,
                      isFavourite: _editedProduct.isFavourite,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if(value.isEmpty)
                      return "Please enter a description";
                    if(value.length < 10)
                      return "Description should be at least 10 characters long.";
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = new Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: value,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                      isFavourite: _editedProduct.isFavourite,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10,),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text("Enter a URL")
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Image URL"),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        // to access the controller on-fly -> for change img
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return "Please enter an image URL.";
                          if (!value.startsWith("http") || !value.startsWith("https"))
                            return "Please enter a valid URL.";
                          /*if (!value.endsWith(".png") && !value.endsWith(".jpg") && !value.endsWith(".jpeg"))
                            return "Please enter a valid Image URL.";
                           */
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = new Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: value,
                              isFavourite: _editedProduct.isFavourite,
                          );
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

