/// Flutter code sample for DropdownButton

// This sample shows a `DropdownButton` with a large arrow icon,
// purple text style, and bold purple underline, whose value is one of "One",
// "Two", "Free", or "Four".
//
// ![](https://flutter.github.io/assets-for-api-docs/assets/material/dropdown_button.png)

import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:convert';
// import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:fstore/common/constants.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart_tests.dart';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  Future<Map<String, dynamic>> _setFeedByPopular() async {
    print('setFeedByPopular:');
    final response = await http.get(Uri.parse(Constants.defaultFeed));
    if (response.statusCode == 200) {
      // print(response.body);
      return jsonDecode(response.body);
    } else {
      // throw Exception('Failed to get news');
      return {'hits': 'my null'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // darkTheme: ThemeData(brightness: Brightness.dark),
      title: _title,
      home: Scaffold(
          appBar: AppBar(title: const Text(_title)),
          body: Container(
            height: double.infinity,
            child: FutureBuilder(
              future: _setFeedByPopular(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> thing_details = snapshot.data['hits'];
                  print('thing_details');
                  print(thing_details);
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: thing_details.length,
                      itemBuilder: (BuildContext context, int i) {
                        return CardGrid(
                            title: thing_details[i]['name'],
                            puclic_url: thing_details[i]['public_url'],
                            image_url: thing_details[i]['preview_image']);
                      });
                }
                return Text('Default');
              },
            ),
          )),
    );
  }
}

class CardGrid extends StatelessWidget {
  final String title;
  final String puclic_url;
  final String image_url;

  CardGrid({this.title = '', this.puclic_url = '', this.image_url = ''});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          launch(puclic_url);
          print(puclic_url);
        },
        child: Container(
          width: double.infinity,
          height: 500,
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: const Offset(-1.0, 1.5),
                blurRadius: 5.0,
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
              ),
            ],
            image: DecorationImage(
                image: NetworkImage(
                  image_url,
                ),
                fit: BoxFit.cover),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(-1.0, 1.5),
                      blurRadius: 5.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
