import 'package:flutter/material.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function onClearPressed;
  final Function onSubmit;
  SearchWidget({required this.controller,required this.hintText, required this.onClearPressed, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    // final TextEditingController _controller = TextEditingController();
    return Container(
      height: 50,
      margin: EdgeInsets.all(5),
      alignment: Alignment.center,
      child:Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 0),
              blurRadius: 1,
              spreadRadius: 0,
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          onFieldSubmitted: (query) {
            onSubmit(query);
          },
          onChanged: (query) {

          },
          textInputAction: TextInputAction.search,
          maxLines: 1,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: hintText,
            isDense: true,
            hintStyle: TextStyle(fontSize: 15),
            border: InputBorder.none,
            // prefixIcon: SvgPicture.asset('assets/svg/search.svg',height: 10,width: 10,color: Colors.black,),
            prefixIcon: Icon(Icons.search,size: 20,),
            suffixIcon: controller.text.isNotEmpty ? IconButton(
              icon: Icon(Icons.clear, color: ColorResources.PRIMARY_COLOR),
              onPressed: () {
                onClearPressed();
                controller.clear();
              },
            ) : controller.text.isNotEmpty ? IconButton(
              icon: Icon(Icons.clear, color: ColorResources.PRIMARY_COLOR),
              onPressed: () {
                onClearPressed();
                controller.clear();
              },
            ) : null,
          ),
        ),
      ),

    );
  }
}
