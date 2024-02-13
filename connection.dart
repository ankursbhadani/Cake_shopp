import 'dart:convert';
import 'package:http/http.dart' as http;

class MyNetworkRequest {
  String GetBaseUrl() {
    return "http://192.168.29.102/flutter_php/ws/";
  }
  String GetImageUrl() {
    return GetBaseUrl() + "images/";
  }

  String GetWebServiceUrl() {
    return GetBaseUrl() + "ws/";
  }

  Future<List<dynamic>> SendRequest(String url,
      [String method = 'get', var form]) async {
    List<dynamic> response = [];
    var res;
    print("Request detail [method = $method] [url = $url]");
    if (form != null) print(form);

    if (method == "get")
      res = await http.get(Uri.parse(GetBaseUrl() + url));
    else if (method == "post")
      res = await http.post(Uri.parse(GetBaseUrl() + url), body: form);
    if (res != null && res.statusCode == 200) {
      print("we got some response from server");
      print(res.body);
      response = jsonDecode(res.body);
    }else{
      print("didnt get from response");
    }
    return response;
  }
}
