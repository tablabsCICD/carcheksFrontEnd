import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'notes.dart';
import 'package:flutter/material.dart';

class WheelsAndTyres extends StatefulWidget {
  @override
  _WheelsAndTyresState createState() => _WheelsAndTyresState();
}

class _WheelsAndTyresState extends State<WheelsAndTyres> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<RadioModel> sampleData = <RadioModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData.add(new RadioModel(true, 'Four-Wheel balancing'));
    sampleData.add(new RadioModel(false, 'Tire pressure (TPMS) light is on'));
    sampleData.add(new RadioModel(false, 'Tire rotation'));
    sampleData.add(new RadioModel(false, 'Wheel alignment'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context,_scaffoldKey,"Wheels & Tires"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 29),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What wheel and tire service do you need?",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
            ListView.builder(
          shrinkWrap: true,
          itemCount: sampleData.length,
          itemBuilder: (BuildContext context, int index) {
            return new InkWell(
              //highlightColor: Colors.red,
              splashColor: Colors.blueAccent,
              onTap: () {
                setState(() {
                  sampleData.forEach((element) => element.isSelected = false);
                  sampleData[index].isSelected = true;
                });
              },
              child: new RadioItem(sampleData[index]),
            );
          },
        ),
            Center(
              child: CustomButton(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>Notes()));
                },
                buttonText: "Continue",isEnable: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String text;
  RadioModel(this.isSelected, this.text);
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15,horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 5.0),
            child:  Text(_item.text,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
          ),
          Container(
            height: 25.0,
            width: 25.0,
            child: Center(
              child:Icon(Icons.check,color: _item.isSelected?Colors.white:Colors.transparent,),
            ),
            decoration: BoxDecoration(
              color: _item.isSelected
                  ? Colors.blueAccent
                  : Colors.transparent,
              border: Border.all(
                  width: 1.0,
                  color: _item.isSelected
                      ? Colors.blueAccent
                      : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(50.0)),
            ),
          ),

        ],
      ),
    );
  }
}