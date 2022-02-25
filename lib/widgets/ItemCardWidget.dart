import 'package:app/pages/item.dart';
import 'package:flutter/material.dart';
import 'package:app/models/item.dart';
import 'package:app/helpers/helper.dart';

class ItemCardWidget extends StatelessWidget {
  final Item item;
  const ItemCardWidget({Key key, this.item}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Card(
            child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ItemPage(item: item)));
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FadeInImage(
                        //image: NetworkImage(Helper.getUri('img/items/' + item.picture).toString()),
                        image: AssetImage('assets/img/logo.png'),
                        placeholder: AssetImage('assets/img/logo.png')
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(item.code),
                    subtitle: Text(item.name),
                    isThreeLine: true,
                  ),
              ],
            ),
        ),
      );
    }
  }