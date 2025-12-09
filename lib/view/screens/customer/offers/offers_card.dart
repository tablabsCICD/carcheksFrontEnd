
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/screens/customer/garage/garage_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class OffersCard extends StatefulWidget {
 // Data garage;
  OffersCard({Key? key}) : super(key: key);

  @override
  State<OffersCard> createState() => _OffersCardState();
}

class _OffersCardState extends State<OffersCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: (){
          //  Navigator.push(context, MaterialPageRoute(builder: (builder)=>StoreDetails()));
          },
          child: Card(
            elevation: 5,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
              decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
               // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 110,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/1.jpg"))),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 20,
                          width: 50,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(7)),
                          child: Center(
                            child: Text(
                              "20% off",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal,color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 0),
                    child: Text(
                      "20% repair class glass",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: ColorResources.PRIMARY_COLOR),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 2),
                    child: Text(
                      "Redbricks Services",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
