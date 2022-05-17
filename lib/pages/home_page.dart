import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterquote/widgets/quote_widget.dart';
import 'package:http/http.dart' as http;
import 'package:random_color/random_color.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var apiURL = "https://type.fit/api/quotes";

  Future<List<dynamic>> getPost() async {
    final response = await http.get(Uri.parse('$apiURL'));
    return postFromJson(response.body);
  }

  List<dynamic> postFromJson(String str) {
    List<dynamic> jsonData = json.decode(str);
    jsonData.shuffle();
    return jsonData;
  }

  RandomColor _randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
          future: getPost(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ErrorWidget(snapshot.error);
              }
              return PageView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var model = snapshot.data[index];
                    return QuoteWidget(
                      quote: model["text"].toString(),
                      author: model["author"].toString(),
                      bgColor: _randomColor.randomColor(
                        colorHue: ColorHue.multiple(
                          colorHues: [ColorHue.red, ColorHue.blue],
                        ),
                      ),
                    );
                  });
            } else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
