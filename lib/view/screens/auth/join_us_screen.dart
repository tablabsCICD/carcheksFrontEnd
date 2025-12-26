
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/screens/auth/registration_page.dart';
import 'package:carcheks/view/screens/customer/customer_car_details.dart';
import '../customer/zip_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JoinUsScreen extends StatefulWidget {
  const JoinUsScreen({super.key});

  @override
  _JoinUsScreenState createState() => _JoinUsScreenState();
}

class _JoinUsScreenState extends State<JoinUsScreen> {
  bool isSelectedGarageOwner = false;

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
                  isSelectedGarageOwner = !isSelectedGarageOwner;
                });
              },
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: isSelectedGarageOwner?Colors.black:ColorResources.PRIMARY_COLOR),
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  //  SvgPicture.asset("assets/svg/customer.svg",height: 50,width: 50,color: isSelectedCustomer?ColorResources.PRIMARY_COLOR:Colors.black,),
                    Icon(Icons.person,size: 40,color: isSelectedGarageOwner?Colors.black:ColorResources.PRIMARY_COLOR),
                    Text("A Customer",style:TextStyle(color: isSelectedGarageOwner?Colors.black:ColorResources.PRIMARY_COLOR)),
                    Icon(isSelectedGarageOwner?Icons.circle_outlined:Icons.check_circle,size: 30,color: isSelectedGarageOwner?Colors.black:ColorResources.PRIMARY_COLOR)
                  ],
                ),
              ),
            ),
            SizedBox(height: 50,),
            InkWell(
              onTap: (){
                setState(() {
                  isSelectedGarageOwner = !isSelectedGarageOwner;
                });
              },
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: isSelectedGarageOwner?ColorResources.PRIMARY_COLOR:Colors.black),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   // SvgPicture.asset("assets/svg/garage_owner.svg",height: 50,width: 50,color: isSelectedCustomer?ColorResources.PRIMARY_COLOR:Colors.black,),
                    Icon(Icons.person,size: 40,color: isSelectedGarageOwner?ColorResources.PRIMARY_COLOR:Colors.black),
                    Text("A Garage Owner",style: TextStyle(color: isSelectedGarageOwner?ColorResources.PRIMARY_COLOR:Colors.black),),
                    Icon(isSelectedGarageOwner?Icons.check_circle:Icons.circle_outlined,size: 30,color: isSelectedGarageOwner?ColorResources.PRIMARY_COLOR:Colors.black)
                  ],
                ),
              ),
            ),
            SizedBox(height: 40,),
            Center(
              child: CustomButton(onTap: (){
                Navigator.pushNamed(context, AppRoutes.register,arguments: {isSelectedGarageOwner});
              }, buttonText: "Continue",isEnable: true,),
            )
          ],
        ),
      ),
    );
  }
}
