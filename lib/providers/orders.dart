import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  final authToken;
  Orders(this.authToken);

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(
        'flutter-shop-app-745ad-default-rtdb.asia-southeast1.firebasedatabase.app',
        'orders.json',
        {"auth": authToken});
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    if (json.decode(response.body) == null) {
      return;
    }
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double totalAmount) async {
    final url = Uri.https(
        'flutter-shop-app-745ad-default-rtdb.asia-southeast1.firebasedatabase.app',
        'orders.json',
        {"auth": authToken});
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': totalAmount,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((citem) => {
                      'id': citem.id,
                      'price': citem.price,
                      'quantity': citem.quantity,
                      'title': citem.title,
                    })
                .toList(),
          }));
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: totalAmount,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
