import 'package:app/widgets/BusinessPartnerCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/business_partner.dart';
import '../controllers/business_partner_controller.dart';

class BusinessPartnerSearchWidget extends StatefulWidget {
  @override
  _BusinessPartnerSearchWidgetState createState() => _BusinessPartnerSearchWidgetState();
}

class _BusinessPartnerSearchWidgetState extends StateMVC<BusinessPartnerSearchWidget> {
  final SearchBarController<BusinessPartner> _searchBarController = SearchBarController();
  BusinessPartnerController _con;

  _BusinessPartnerSearchWidgetState() : super(BusinessPartnerController()) {
    _con = controller;
  }

  bool isReplay = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchBar<BusinessPartner>(
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _con.getBusinessPartners,
          searchBarController: _searchBarController,
          cancellationWidget: Text("Cancelar"),
          emptyWidget: Text("Sin resultados"),
          header: Row(
            children: <Widget>[
              OutlineButton(
                child: Text("Ordenar"),
                onPressed: () {
                  _searchBarController.sortList((BusinessPartner a, BusinessPartner b) {
                    return a.name.compareTo(b.name);
                  });
                },
              ),
              OutlineButton(
                child: Text("Desordenar"),
                onPressed: () {
                  _searchBarController.removeSort();
                },
              ),
            ],
          ),
          onCancelled: () {
            //
          },
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 1,
          onItemFound: (BusinessPartner businessPartner, int index) {
            return BusinessPartnerCardWidget(businessPartner: businessPartner);
          },
        ),
      ),
    );
  }
}