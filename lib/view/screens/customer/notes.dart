
import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'date_screen.dart';
import 'wheels_tyres_1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  Garage? garage;
  Notes({this.garage});

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController notesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context,_scaffoldKey,"Technician Notes"),
      body: SingleChildScrollView(
        child: Column(
          //shrinkWrap: true,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              margin: EdgeInsets.symmetric(horizontal: 35,vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey[200]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Notes For Technician",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: (){
                             Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Please provide any notes about the issue that may help the technician with your wheel alignment Adjustment.",style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal),),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      maxLines: 10,
                      controller: notesController,
                      decoration: InputDecoration(
                        hintText: "Required!",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: CustomButton(
                  onTap: (){ if(notesController.text.isNotEmpty){
                   // Navigator.push(context, MaterialPageRoute(builder: (builder)=>ChooseDate(garage: widget.garage,notes: notesController.text,)));
                    Navigator.pushNamed(context, AppRoutes.date,arguments: {widget.garage,notesController.text});
                  }
                  else{
                     var snackBar = SnackBar(content: Text('Please provide some instructions for technician!'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);}
                  },
                  buttonText: "Continue",
        
              ),
            )
          ],
        ),
      ),
    );
  }
}
