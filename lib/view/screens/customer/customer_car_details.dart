import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/custom_textfield.dart';
import 'package:carcheks/view/screens/customer/vehicle/add_vehicle_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomerCarDetails extends StatefulWidget {
  @override
  _CustomerCarDetailsState createState() => _CustomerCarDetailsState();
}

class _CustomerCarDetailsState extends State<CustomerCarDetails> {
  TextEditingController customerNameController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController regNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 30,
              )),
          title: Text(
            "Customer Car Details",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          )),
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
                      CustomTextField(
                        controller: customerNameController,
                        hintText: "Enter Your Name",
                        lableText: "Customer Name",
                        textInputType: TextInputType.text,
                      ),
                      CustomTextField(
                        controller: carModelController,
                        hintText: "Enter Car Model",
                        lableText: "Car Model",
                        textInputType: TextInputType.text,
                      ),
                      CustomTextField(
                        controller: regNumberController,
                        hintText: "Enter Registration Number",
                        lableText: "Registration Number",
                        textInputType: TextInputType.text,
                      ),
                      CustomTextField(
                        controller: nameController,
                        hintText: "Lorem Ipsum",
                        lableText: "Lorem Ipsum",
                        textInputType: TextInputType.text,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.vignette_sharp,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(
                        "Following are the best Flutter packages which can generate lorem ispum text Lorem Ipsum is simply dummy text used in many programming language.",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: CustomButton(
                  buttonText: "Save",
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => AddVehicleInfo(
                                  isdashboard: false,
                                )));
                  },isEnable: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
