import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

// Future<String> iCreditGetUrl(
Future<String> iCreditGetUrl(
    {buyer_name, city, street, email, phone, total_price}) async {
  var url =
      'https://testicredit.rivhit.co.il/API/PaymentPageRequest.svc/GetUrl';

  var req = {
    'GroupPrivateToken': 'bb8a47ab-42e0-4b7f-ba08-72d55f2d9e41',
    'Items': [
      {
        'Id': 1,
        'Quantity': 1,
        'UnitPrice': total_price,
        'Description': 'תשלום מאובטח ביישומון Spider3D'
      }
    ],
    // 'FailRedirectURL': 'String content',
    // 'Order': 'Woo order number?',

    'CustomerFirstName': buyer_name,
    // 'CustomerLastName': 'String content',
    'City': city,
    'Address': street,
    'EmailAddress': email,
    'PhoneNumber': phone,

    'MaxPayments': 12,
    'RedirectURL':
        'https://www.spider3d.co.il/%D7%AA%D7%95%D7%93%D7%94/', // spider3d.co.il/תודה
    'DisplayPayPalButton': 'false',
    'CreateToken': 'true'
  };

  var dio = Dio();
  final resp = await dio.post(url, data: req);

  // print(resp.data);
  // print(resp.data['PrivateSaleToken']);
  // print(resp.data['URL']);
  return resp.data['URL'].toString();
}

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
