import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:carcheks/locator.dart';
import 'package:carcheks/model/address_model.dart';
import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/provider/address_provider.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/review_provider.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/util/style.dart';
import 'package:carcheks/view/base_widgets/box_button.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/custom_navigation_drawer_widget.dart';
import 'package:carcheks/view/base_widgets/getImage.dart';
import 'package:carcheks/view/base_widgets/search_widget.dart';
import 'package:carcheks/view/base_widgets/star_display.dart';
import 'package:carcheks/view/screens/auth/profile_page.dart';
import 'package:carcheks/view/screens/customer/cart/my_cart.dart';
import 'package:carcheks/view/screens/customer/customer_dashboard.dart';
import 'package:carcheks/view/screens/customer/service/garage_service_card.dart';
import 'package:carcheks/view/screens/customer/service/service_card.dart';
import 'package:carcheks/view/screens/customer/wheels_tyres_1.dart';
import 'package:carcheks/view/screens/customer/notes.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../base_widgets/rating_star.dart';
import '../search_page.dart';
import '../service_search.dart';
import '../../../base_widgets/getCart.dart';

class GarageDetails extends StatefulWidget {
  Garage garage;
  ReviewProvider reviewProvider = locator<ReviewProvider>();

  GarageDetails(this.garage, {Key? key}) : super(key: key) {
    reviewProvider.getReviewByGarageId(garage.id);
  }

  @override
  _GarageDetailsState createState() => _GarageDetailsState();
}

class _GarageDetailsState extends State<GarageDetails> {
  String text =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum ";
  String chatText =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.";
  List<ImageCarousel> _imageUrls = [
  ];

  int _current = 0;
  bool isCarSelected = true;
  bool isGSelected = false;
  TextEditingController searchTextController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ServiceProvider serviceProvider = locator<ServiceProvider>();
  AddressProvider addressProvider = locator<AddressProvider>();
  AuthProvider authProvider = locator<AuthProvider>();
  AddressClass? addressClass;
  TextEditingController reviewController = TextEditingController();
  double rating = 0;

  @override
  void initState() {
    serviceProvider.getGarageServicesByGarageId(widget.garage.id);
    _imageUrls.add(ImageCarousel(widget.garage.imageUrl, '', ''));
    _imageUrls.add(ImageCarousel(widget.garage.photos1, '', ''));
    _imageUrls.add(ImageCarousel(widget.garage.photos2, '', ''));
    _imageUrls.add(ImageCarousel(widget.garage.photos3, '', ''));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: ColorResources.APPBAR_COLOR,
        title: Text(
          widget.garage.name.toUpperCase(),
          style: Style.TITLE,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: ColorResources.BUTTON_COLOR,
          ),
          //SvgPicture.asset("assets/svg/hamburger.svg"),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: getImage(authProvider.user!.imageUrl.toString()),
          ),
          SizedBox(
            width: 10,
          ),
          GetCart(
            userId: authProvider.user!.id,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  SizedBox(
                    height: 15,
                  ),
                  getImageSlider(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Open at ${widget.garage.openingTime} ",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorResources.BUTTON_COLOR),
                          ),
                          Text(
                            "Closes at ${widget.garage.closingTime}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorResources.RED),
                          ),
                        ],
                      ),


                      Row(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            elevation: 5,
                            child: InkWell(
                              onTap: () {
                                launch("tel:${widget.garage.contactNumber}");
                              },

                              child: Padding(
                                  padding: EdgeInsets.all(7.0),
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.green,
                                    size: 18,
                                  )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => MyCart()));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: SvgPicture.asset(
                                  "assets/svg/menu_cart.svg",
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => ServiceSearch()));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: SvgPicture.asset(
                                  "assets/svg/menu_search.svg",
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.garage.name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.BUTTON_COLOR),
                      ),
                      Text(
                        widget.garage.noOfRating.toString() + " Rating",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            color: ColorResources.PRIMARY_COLOR),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "${widget.garage.addressDtls?.street}, ${widget.garage.addressDtls?.landmark}, "
                            "${widget.garage.addressDtls?.houseName}, " +
                        "${widget.garage.addressDtls?.cityname}, ${widget.garage.addressDtls?.zipCode}",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Highlights",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.garage.discription,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "See All Services",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  getServices(widget.garage),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Rate your experience with ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  StarRating(
                    rating: rating,
                    onRatingChanged: (rating) =>
                        setState(() => this.rating = rating),
                  ),

                  SizedBox(
                    height: 7,
                  ),
                  writeReview(),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Consumer<ReviewProvider>(
                        builder: (context, model, child) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            foregroundColor: Colors.white
                          ),
                          onPressed: () async {
                            if (reviewController.text.isNotEmpty) {

                              if(rating==0){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Please select rating'),
                                  backgroundColor: Colors.red,
                                ));
                              }else{
                                var result = await model.addReview(
                                    garageId: widget.garage.id,
                                    comments: reviewController.text,
                                    rating: rating);
                                if (result['success'] == false) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        'something went wrong to submit review'),
                                    backgroundColor: Colors.red,
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                    Text('review submitted successfully'),
                                    backgroundColor: Colors.green,
                                  ));
                                  await model
                                      .getReviewByGarageId(widget.garage.id);
                                }
                              }


                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Please give some comments'),
                                backgroundColor: Colors.red,
                              ));
                            }
                          },
                          child: Text("Submit Review"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  getChatList(),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BoxButton(
        buttonText: "Continue",
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => MyCart()));
        },
      ),
    );
  }

  int index = -1;

  getImageSlider() {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 160.0,
            aspectRatio: 16 / 9,
            enlargeCenterPage: false,
            viewportFraction: 1.0,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: _imageUrls.map((i) {
            index++;
            return Builder(builder: (BuildContext context) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: _imageUrls[_current] == ''
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "assets/images/1.jpg",
                            )))
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              widget.garage.imageUrl
                            ))),
              );
            });
          }).toList(),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _imageUrls.map((i) {
                int index = _imageUrls.indexOf(i);
                return Container(
                  width: 7.0,
                  height: 7.0,
                  margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? ColorResources.PRIMARY_COLOR
                        : Colors.black.withOpacity(0.5),
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  getServices(Garage garage) {
    return Consumer<ServiceProvider>(
      builder: (context, model, child) => Container(
        height: 150,
        child: model.garageServiceListByGarageId.isEmpty?Text("Garage Services not added.."):ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: model.garageServiceListByGarageId.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 150,
                  width: 150,
                  margin: EdgeInsets.all(5),
                  child: GarageServiceCard(
                      model.garageServiceListByGarageId[index],
                      cost: true));
              // child: GServiceCard(model.garageServiceListByGarageId[index],widget.garage));
            }),
      ),
    );
  }

  /*getServices() {
    return Container(
      height: 125,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 100,
                width: 125,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.cyan[100],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      size: 50,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Flat Tire")
                  ],
                ),
              ),
            );
          }),
    );
  }
*/
  getChatList() {
    return Consumer<ReviewProvider>(
      builder: (context, model, child) => Container(
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.reviewListByGarageId.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        getImage(
                            model.reviewListByGarageId[index].userTable == null
                                ? ''
                                : model.reviewListByGarageId[index].userTable!
                                            .imageUrl ==
                                        ''
                                    ? ''
                                    : model.reviewListByGarageId[index]
                                        .userTable!.imageUrl),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                            model.reviewListByGarageId[index].userTable!
                                    .firstName +
                                model.reviewListByGarageId[index].userTable!
                                    .lastName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))
                      ],
                    ),
                    Row(
                      children: [
                        StarDisplay(
                            value: model.reviewListByGarageId[index].rating!),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                            model.reviewListByGarageId[index].updated
                                .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(model.reviewListByGarageId[index].comments.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 12)),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 2,
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  writeReview() {
    return Container(
      height: 90,
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.only(bottom: 16.0),
      child: TextField(
        maxLines: 9,
        controller: reviewController,
        decoration: InputDecoration(
          hintText: "Your Feedback!",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
