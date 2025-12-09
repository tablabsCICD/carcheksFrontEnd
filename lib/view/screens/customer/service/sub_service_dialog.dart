import 'dart:ui';

import 'package:carcheks/locator.dart';
import 'package:carcheks/model/services.dart';
import 'package:carcheks/model/subservices_model.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:carcheks/util/style.dart';
import 'package:carcheks/view/screens/customer/garage/near_by_store.dart';
import 'package:carcheks/view/screens/customer/notes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:collection/collection.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../../../util/app_constants.dart';

class SubServiceCustomDialogBox extends StatefulWidget {
  MainService service;
  bool? cost;
  SubServiceCustomDialogBox(this.service, this.cost);


  @override
  _SubServiceCustomDialogBoxState createState() => _SubServiceCustomDialogBoxState();
}

class _SubServiceCustomDialogBoxState extends State<SubServiceCustomDialogBox> {
  final model = locator<ServiceProvider>();

 List<bool> _selected = [];

  List<SubService> selectedList = [];
  @override
  void initState() {
    super.initState();
    model.getSubServicesByServiceId(serviceId: widget.service.id);
    _selected = List<bool>.generate(20, (int index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Consumer<ServiceProvider>(
        builder: (context, model, child) =>model.isLoading==true?Container(height: 100,color: Colors.white, child: Center(child: CircularProgressIndicator())): Container(
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 45,left: 0,right: 0,bottom: 50),

            width: 600,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black,offset: Offset(0,10),
                      blurRadius: 10
                  ),
                ]
            ),
            child:SingleChildScrollView(
              child: Column
                (
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Select Services",style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),),
                  SizedBox(
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        _createDataTable()
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width:2),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Background color
                            foregroundColor: Colors.white, // Foreground (text) color
                          ),
                          onPressed: (){
                            if(selectedList.isNotEmpty){
                              Navigator.pushReplacement(context,MaterialPageRoute(builder: (builder)=>
                                  NearByStore(selectedList: selectedList,fromScreen: 'Filter',)));

                            }else{
                              showSimpleNotification(
                                  Text(
                                    "If you want to procced,select atleast one service, otherwise click on cancel button",
                                    style: TextStyle(
                                        color: Colors.white),
                                  ),
                                  background: Colors.black);
                           }
                          },
                          child: Text( 'Select Garage',style: Style.subServicebutton),
                        ),
                      ),
                      SizedBox(width: 3,),
                      Expanded(
                        child:ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Background color
                            foregroundColor: Colors.white, // Foreground (text) color
                          ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text( 'Cancel',style: Style.subServicebutton),
                      ),
                      ),
                      SizedBox(width:2),

                    ],

                  )
                ],
              ),
            ),
        ),
      ),
    );
  }

  DataTable _createDataTable() {
    return DataTable(showBottomBorder:true,columns: _createColumns(), rows: _createRows());
  }
  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text(widget.service.name.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),)),
      widget.cost==true?DataColumn(label: Text('Cost',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),)):DataColumn(label: Text(''))
    ];
  }
  List<DataRow> _createRows() {
    return model.subServiceListByServiceId
        .mapIndexed((index, book) => DataRow(

        cells: [
          DataCell(Consumer<ServiceProvider>(
              builder: (context, model, child) => Text(model.subServiceListByServiceId[index].name))),
          widget.cost==true?DataCell(Consumer<ServiceProvider>(
              builder: (context, model, child) => Text(model.subServiceListByServiceId[index].costing))):DataCell(Text(''))
        ],
        selected: _selected[index],
        onSelectChanged: (bool? selected) {
          setState(() {
            _selected[index] = selected!;
          });
          selectedList.add(model.subServiceListByServiceId[index]);


        }))
        .toList();
  }


}