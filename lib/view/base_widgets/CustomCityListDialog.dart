import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomCityListDialog extends StatefulWidget {
  Function onTap;
  CustomCityListDialog({required this.onTap});


  @override
  _CustomCityListDialogState createState() => _CustomCityListDialogState();
}

class _CustomCityListDialogState extends State<CustomCityListDialog> {
  List<dynamic> foundCity = [];
  List<dynamic> uniquFoundCity = [];
  List<dynamic> cityList = [];

  getCity() async {
    String myUrl = 'https://api.tkdost.com/tkd2/api/get/cities/db';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    var response = json.decode(req.body);
    setState(() {
      cityList = response;
    });
    foundCity = cityList.toSet().toList();
  }

  @override
  initState() {
    getCity();
    foundCity = cityList..toSet().toList();
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = cityList;
    } else {
      results = cityList
          .where((user) =>
          user.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundCity = results.toSet().toList();
      //  foundCity = uniquFoundCity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select City'),
      content: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const InputDecoration(
                    labelText: 'Search', suffixIcon: Icon(Icons.search)),
              ),
              const SizedBox(
                height: 20,
              ),
              cityList.isEmpty?
              CircularProgressIndicator()
                  :Container(
              //  height: ResponsiveWidget.isDesktop(context)?500:400,
                width: 300,
                child: foundCity.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: foundCity.length,
                  itemBuilder: (context, index) =>
                      Column(
                        children: [
                          ListTile(
                            onTap: () {
                             // Navigator.pop(context,[foundCity[index].toString(),foundCity[index].toString()]);
                              widget.onTap(foundCity[index].toString());
                              Navigator.of(context).pop();
                            },
                             title: Text(foundCity[index]),
                          ),
                          Divider(),
                        ],
                      ),

                )
                    : const Text(
                  'No results found',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
