import 'dart:convert';

import 'package:http/http.dart' as http;
class APIHelper {

  ApiPostData(String URL) async{
    var req= await http.post(Uri.parse(URL));
    var response= json.decode(req.body);
    return response;
  }
  ApiPutData(String URL) async{
    var req= await http.put(Uri.parse(URL));
    var response= json.decode(req.body);
    return response;
  }
  ApiDeleteData(String URL) async{
    var req= await http.delete(Uri.parse(URL));
    var response= json.decode(req.body);
    return response;
  }
  ApiGetData(String URL) async{
    var req = await http.get(Uri.parse(URL));
    var response = json.decode(req.body);
    return response;
  }


}