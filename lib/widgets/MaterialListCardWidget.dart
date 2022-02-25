import 'package:app/models/material_list.dart';
import 'package:app/pages/material_list.dart';
import 'package:flutter/material.dart';

class MaterialListCardWidget extends StatelessWidget {
  final MaterialList materialList;
  const MaterialListCardWidget({Key key, this.materialList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MaterialListPage(materialList: materialList)));
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
              title: Text(materialList.code),
              subtitle: Text(materialList.name),
              isThreeLine: true,
            ),
          ],
        ),
      ),
    );
  }
}