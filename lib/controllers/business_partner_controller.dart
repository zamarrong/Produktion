import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/business_partner.dart';
import '../repository/business_partner_repository.dart';
import '../repository/search_repository.dart';

class BusinessPartnerController extends ControllerMVC {
  List<BusinessPartner> businessPartners = <BusinessPartner>[];

  BusinessPartnerController() {
    listenForBusinessPartners();
  }

  void listenForBusinessPartners({String search}) async {
    businessPartners = <BusinessPartner>[];
    if (search == null) {
      search = await getRecentSearch();
    }
    if (search.length > 0) {
      final Stream<BusinessPartner> stream = await searchBusinessPartners(search);
      stream.listen((BusinessPartner _businessPartner) {
        setState(() => businessPartners.add(_businessPartner));
      }, onError: (a) {
        print(a);
      }, onDone: () {});
    }
  }

  Future<List<BusinessPartner>> getBusinessPartners(String search) async {
    businessPartners = <BusinessPartner>[];
    if (search == null) {
      search = await getRecentSearch();
    }
    if (search.length > 0) {
      final Stream<BusinessPartner> stream = await searchBusinessPartners(search);
      await for(BusinessPartner _item in stream) {
        businessPartners.add(_item);
      }
      saveSearch(search);
      return businessPartners;
    }

    return businessPartners;
  }

  Future<void> refreshSearch(search) async {
    setState(() {
      businessPartners = <BusinessPartner>[];
    });
    listenForBusinessPartners(search: search);
  }

  void saveSearch(String search) {
    setRecentSearch(search);
  }
}
