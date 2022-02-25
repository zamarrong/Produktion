import 'package:app/widgets/DrawerWidget.dart';
import 'package:app/widgets/BusinessPartnerSearchWidget.dart';
import 'package:flutter/material.dart';

class BusinessPartnersPage extends StatelessWidget {

  static const String routeName = '/business-partners';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Socios de negocios"),
      ),
      drawer: DrawerWidget(),
      body: SafeArea(
        child: BusinessPartnerSearchWidget(),
      ),
    );
  }
}