import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

// Future<String> iCreditGetUrl(
Future<String> iCreditGetUrl() async {
  var url =
      'https://testicredit.rivhit.co.il/API/PaymentPageRequest.svc/GetUrl';

  var dio = Dio();
  final resp = await dio.get(url);

  // print(resp.data);
  // print(resp.data['PrivateSaleToken']);
  // print(resp.data['URL']);
  return resp.data['URL'].toString();
}

void main() async {
  var url = await iCreditGetUrl();
  print(url);
}
