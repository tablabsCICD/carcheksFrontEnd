import 'dart:ui';

import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/custom_textfield.dart';
import 'package:carcheks/view/screens/customer/zip_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarOwnerDetails extends StatefulWidget {
  @override
  _CarOwnerDetailsState createState() => _CarOwnerDetailsState();
}

class _CarOwnerDetailsState extends State<CarOwnerDetails> {
  TextEditingController addressController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.white,size: 30,)),
          title: Text("Car Owner Details",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),)
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blueAccent,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      getProfile(
                        "assets/images/1.jpg",
                        "KSR Services"
                      ),
                      SizedBox(height: 10,),
                      CustomTextField(
                        controller: addressController,
                        hintText: "Enter Address",
                        lableText: "Address",
                        textInputType: TextInputType.text,
                      ),
                      CustomTextField(
                        controller: zipCodeController,
                        hintText: "Enter Zip Code",
                        lableText: "Zip Code",
                        textInputType: TextInputType.text,
                      ),
                      CustomTextField(
                        controller: phoneNumberController,
                        hintText: "Enter Phone Number",
                        lableText: "Phone Number",
                        textInputType: TextInputType.text,
                      ),
                      CustomTextField(
                        controller: emailController,
                        hintText: "Email",
                        lableText: "Enter Email Id",
                        textInputType: TextInputType.text,
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: CustomButton(
                          buttonText: "Continue",
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (builder)=>ZipCode()));
                          },isEnable: true,
                        ),
                      )
                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  getProfile(String img, String name) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Center(
                child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/1.jpg')
                        )
                    )),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Card(
                   // elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      height: 35,
                      width: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit,),
                        onPressed: (){},
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Text("KSR Services",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 20))
        ],
      ),
    );

  }
}
