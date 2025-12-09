/*
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomStateListDialog extends StatefulWidget {
  Function onTap;
  CustomStateListDialog({required this.onTap});


  @override
  _CustomStateListDialogState createState() => _CustomStateListDialogState();
}

class _CustomStateListDialogState extends State<CustomStateListDialog> {
  List<States> foundState = [];
  List<States> uniquFoundState = [];
  List<States> stateList = [];

  getState() async {
    String myUrl = 'https://api.tkdost.com/tkd2/api/get/statesnew';
    var req = await http.get(Uri.parse(myUrl));
    var response = json.decode(req.body);
    var type = StateModel.fromJson(response);
    stateList=type.result;
    setState(() {
      stateList = type.result;
    });
    foundState = stateList.toSet().toList();
  }

  @override
  initState() {
    getState();
    foundState = stateList..toSet().toList();
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<States> results = [];
    if (enteredKeyword.isEmpty) {
      results = stateList;
    } else {
      results = stateList
          .where((user) =>
          user.region.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundState = results.toSet().toList();
      //  foundCity = uniquFoundCity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select State'),
      content: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const SizedBox(
            //   height: 20,
            // ),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 500,
              width: 300,
              child: foundState.isNotEmpty
                  ? ListView.builder(
                shrinkWrap: true,
                itemCount: foundState.length,
                itemBuilder: (context, index) =>
                    Column(
                      children: [
                        ListTile(
                          onTap: () {
                           // Navigator.pop(context,[foundState[index].region.toString(),foundState[index].toString()]);
                            widget.onTap(foundState[index].region.toString());
                            Navigator.of(context).pop();
                          },
                          title: Text(foundState[index].region.toString()),
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
    );
  }
}
*/
