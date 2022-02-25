import 'package:app/models/business_partner.dart';
import 'package:flutter/material.dart';

class BusinessPartnerCardWidget extends StatelessWidget {
  final BusinessPartner businessPartner;
  const BusinessPartnerCardWidget({Key key, this.businessPartner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              child: Text(
                businessPartner.name.substring(0, 1),
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              backgroundColor: businessPartner.cardType == 'C' ? Colors.blue : Colors.blueGrey,
            ),
            title: Text(businessPartner.code),
            subtitle: Text(businessPartner.name + '\nRFC: ' + businessPartner.licTradNum + '\nCelular: ' + businessPartner.cellular + ' Email: ' + businessPartner.email),
            isThreeLine: true,
          ),
        ],
      ),
    );
  }
}