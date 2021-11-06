import 'frameworks/woocommerce/services/woo_commerce.dart';

void main() async {
  var url = await iCreditGetUrl(
      buyer_name: 'IDAN TEST',
      city: 'Gedera test',
      street: 'Hedera',
      email: 'idan@test.cocom',
      phone: '0543232761',
      total_price: 301);
  print(url);
}
