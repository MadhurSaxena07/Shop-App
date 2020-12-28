import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screen/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;
  UserProductItem(this.id, this.title, this.imgUrl);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routename, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  Provider.of<Products>(context, listen: false).deleteP(id);
                } catch (error) {
                  scaffold.showSnackBar(
                      SnackBar(content: Text('Error in deleting')));
                }
              },
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
