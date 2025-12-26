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
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.";
  String chatText =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.";

  List<ImageCarousel> _imageUrls = [];

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
    super.initState();
    serviceProvider.getGarageServicesByGarageId(widget.garage.id);
    _imageUrls.add(ImageCarousel(widget.garage.imageUrl, '', ''));
    _imageUrls.add(ImageCarousel(widget.garage.photos1, '', ''));
    _imageUrls.add(ImageCarousel(widget.garage.photos2, '', ''));
    _imageUrls.add(ImageCarousel(widget.garage.photos3, '', ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: ColorResources.APPBAR_COLOR,
        title: Text(widget.garage.name.toUpperCase(), style: Style.TITLE),
        leading: IconButton(
          icon: Icon(Icons.menu, color: ColorResources.BUTTON_COLOR),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfilePage()),
            ),
            child: getImage(authProvider.user!.imageUrl.toString()),
          ),
          const SizedBox(width: 10),
          GetCart(userId: authProvider.user!.id),
          const SizedBox(width: 10),
        ],
      ),
      drawer: DrawerWidget(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getImageSlider(),
              const SizedBox(height: 20),

              _timeRow(),
              const SizedBox(height: 20),

              _garageTitle(),
              const SizedBox(height: 12),

              _addressText(),
              const SizedBox(height: 15),

              _sectionTitle("Highlights"),
              Text(
                widget.garage.discription,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              _sectionTitle("See All Services"),
              const SizedBox(height: 10),
              getServices(widget.garage),

              const SizedBox(height: 25),
              _sectionTitle("Rate your experience"),

              StarRating(
                rating: rating,
                onRatingChanged: (r) => setState(() => rating = r),
              ),

              const SizedBox(height: 10),
              writeReview(),

              const SizedBox(height: 10),
              _submitReviewButton(),

              const SizedBox(height: 30),
              getChatList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: BoxButton(
            buttonText: "Continue",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MyCart()),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );

  Widget _garageTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.garage.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorResources.BUTTON_COLOR,
          ),
        ),
        Text(
          "${widget.garage.noOfRating} Rating",
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: ColorResources.PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }

  Widget _addressText() {
    return Text(
      "${widget.garage.addressDtls?.street}, "
      "${widget.garage.addressDtls?.landmark}, "
      "${widget.garage.addressDtls?.houseName}, "
      "${widget.garage.addressDtls?.cityname}, "
      "${widget.garage.addressDtls?.zipCode}",
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _timeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Open at ${widget.garage.openingTime}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorResources.BUTTON_COLOR,
              ),
            ),
            Text(
              "Closes at ${widget.garage.closingTime}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorResources.RED,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _iconButton(Icons.call, () {
              launch("tel:${widget.garage.contactNumber}");
            }),
            _iconButton(Icons.shopping_cart, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MyCart()),
              );
            }),
            _iconButton(Icons.search, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ServiceSearch()),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.green, size: 18),
          ),
        ),
      ),
    );
  }

  Widget _submitReviewButton() {
    return Center(
      child: Consumer<ReviewProvider>(
        builder: (context, model, child) => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
          ),
          onPressed: () async {
            if (reviewController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please give some comments')),
              );
              return;
            }
            if (rating == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select rating')),
              );
              return;
            }

            var result = await model.addReview(
              garageId: widget.garage.id,
              comments: reviewController.text,
              rating: rating,
            );

            if (result['success']) {
              reviewController.clear();
              FocusScope.of(context).unfocus();
              rating = 0;
              await model.getReviewByGarageId(widget.garage.id);
            }
          },
          child: const Text("Submit Review",style: TextStyle(color: Colors.white),),
        ),
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
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: _imageUrls[_current] == ''
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/1.jpg"),
                          ),
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.garage.imageUrl),
                          ),
                        ),
                );
              },
            );
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
        ),
      ],
    );
  }

  getServices(Garage garage) {
    return Consumer<ServiceProvider>(
      builder: (context, model, child) => Container(
        height: 150,
        child: model.garageServiceListByGarageId.isEmpty
            ? Text("Garage Services not added..")
            : ListView.builder(
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
                      cost: true,
                    ),
                  );
                  // child: GServiceCard(model.garageServiceListByGarageId[index],widget.garage));
                },
              ),
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
                            : model
                                      .reviewListByGarageId[index]
                                      .userTable!
                                      .imageUrl ==
                                  ''
                            ? ''
                            : model
                                  .reviewListByGarageId[index]
                                  .userTable!
                                  .imageUrl,
                      ),
                      SizedBox(width: 15),
                      Text(
                        model.reviewListByGarageId[index].userTable!.firstName +
                            model
                                .reviewListByGarageId[index]
                                .userTable!
                                .lastName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      StarDisplay(
                        value: model.reviewListByGarageId[index].rating!,
                      ),
                      SizedBox(width: 10),
                      Text(
                        model.reviewListByGarageId[index].updated.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    model.reviewListByGarageId[index].comments.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 2),
                ],
              ),
            );
          },
        ),
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
