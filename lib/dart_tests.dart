import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

void main() async {
  var url =
      'https://testicredit.rivhit.co.il/API/PaymentPageRequest.svc/GetUrl';

  var req = {
    'GroupPrivateToken': 'bb8a47ab-42e0-4b7f-ba08-72d55f2d9e41',
    'Items': [
      {
        'Id': 1,
        'Quantity': 3,
        'UnitPrice': 55.9,
        'Description': 'שרשרת פנינים '
      }
    ],
    'RedirectURL': 'http://www.rivhit.co.il',
    'FailRedirectURL': 'String content',
    'MaxPayments': 12,
    'Order': 'String content',
    'EmailAddress': 'String content',
    'CustomerLastName': 'String content',
    'CustomerFirstName': 'String content',
    'Address': 'String content',
    'City': 'String content',
    'PhoneNumber': 'String content',
    'DisplayPayPalButton': 'false',
    'CreateToken': 'true'
  };

  var dio = Dio();
  final resp = await dio.post(url, data: req);

  // print(resp.data);
  print(resp.data['PrivateSaleToken']);
  print(resp.data['URL']);
}
