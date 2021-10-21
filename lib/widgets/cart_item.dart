import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final String id;
  final double price;
  final String title;
  final int quantity;

  CartItem({required this.productId, required this.id, required this.price, required this.title, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(title: Text("Are you sure?"), content: Text("Do you want to remove the item from the cart?"), actions: [
              FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  }),
              FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  })
            ]),
          );
        },
        onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false).removeItem(productId);
        },
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        ),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: FittedBox(
                  child: CircleAvatar(
                child: Text('\$$price'),
              )),
              title: Text(title),
              subtitle: Text('Total: \$${(price * quantity)}'),
              trailing: Text('${quantity}x'),
            ),
          ),
        ));
  }
}
