import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  @override
  final String title;
  final String imageUrl;

  UserProductItem({required this.title, required this.imageUrl});

  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(top: 20, left: 10),
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
          width: 100,
          child: Row(children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.edit, color: Theme.of(context).primaryColor)),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                )),
          ])),
    );
  }
}
