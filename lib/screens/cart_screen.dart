import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';

import '../providers/cart.dart' show Cart;

import '../providers/orders.dart';
import './orders_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Cart"),
        ),
        body: Column(children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cart: cart),
                  ],
                )),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
            itemCount: cart.itemsCount,
            itemBuilder: (ctx, i) => CartItem(
              productId: cart.items.keys.toList()[i],
              id: cart.items.values.toList()[i].id,
              price: cart.items.values.toList()[i].price,
              quantity: cart.items.values.toList()[i].quantity,
              title: cart.items.values.toList()[i].title,
            ),
          ))
        ]));
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              try {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
                widget.cart.clearCart();
                Navigator.of(context).pushNamed(OrdersScreen.routeName);
              } catch (e) {
                print(e);
              }
              setState(() {
                _isLoading = false;
              });
            },
    );
  }
}
