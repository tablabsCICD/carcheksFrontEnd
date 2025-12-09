
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/screens/auth/registration_page.dart';
import 'package:carcheks/view/screens/customer/customer_car_details.dart';
import '../customer/zip_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JoinUsScreen extends StatefulWidget {
  @override
  _JoinUsScreenState createState() => _JoinUsScreenState();
}

class _JoinUsScreenState extends State<JoinUsScreen> {
  bool isSelected = false,isSelectedCustomer = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50,horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Join Us....",style: TextStyle(fontSize: 20),),
            SizedBox(height: 40,),
            InkWell(
              onTap: (){
                setState(() {
                  isSelectedCustomer = !isSelectedCustomer;
                  isSelected = !isSelected;
                });
              },
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: isSelectedCustomer?ColorResources.PRIMARY_COLOR:Colors.black),
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  //  SvgPicture.asset("assets/svg/customer.svg",height: 50,width: 50,color: isSelectedCustomer?ColorResources.PRIMARY_COLOR:Colors.black,),
                    Icon(Icons.person,size: 40,color: isSelectedCustomer?ColorResources.PRIMARY_COLOR:Colors.black),
                    Text("A Customer",style:TextStyle(color: isSelectedCustomer?ColorResources.PRIMARY_COLOR:Colors.black)),
                    Icon(isSelectedCustomer?Icons.check_circle:Icons.circle_outlined,size: 30,color: isSelectedCustomer?ColorResources.PRIMARY_COLOR:Colors.black)
                  ],
                ),
              ),
            ),
            SizedBox(height: 50,),
            InkWell(
              onTap: (){
                setState(() {
                  isSelected = !isSelected;
                  isSelectedCustomer = !isSelectedCustomer;
                });
              },
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: isSelected?ColorResources.PRIMARY_COLOR:Colors.black),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   // SvgPicture.asset("assets/svg/garage_owner.svg",height: 50,width: 50,color: isSelectedCustomer?ColorResources.PRIMARY_COLOR:Colors.black,),
                    Icon(Icons.person,size: 40,color: isSelected?ColorResources.PRIMARY_COLOR:Colors.black),
                    Text("A Garage Owner",style: TextStyle(color: isSelected?ColorResources.PRIMARY_COLOR:Colors.black),),
                    Icon(isSelected?Icons.check_circle:Icons.circle_outlined,size: 30,color: isSelected?ColorResources.PRIMARY_COLOR:Colors.black)
                  ],
                ),
              ),
            ),
            SizedBox(height: 40,),
            Center(
              child: CustomButton(onTap: (){
              //  Navigator.push(context, MaterialPageRoute(builder: (builder)=>RegistrationScreen(isSelectedCustomer,isSelected)));
                Navigator.pushNamed(context, AppRoutes.register,arguments: {isSelectedCustomer,isSelected});
              }, buttonText: "Continue"),
            )
          ],
        ),
      ),
    );
  }
}
