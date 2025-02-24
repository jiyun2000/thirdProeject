import 'dart:convert';
import 'package:http/http.dart' as http;

Future authenticate(String username, String password) async {
  var response = await http.post(
    Uri.parse('<http://localhost:8080/auth/refresh>'),
    body: {
      'username':username,
      'password':password,
    },
  );

  if(response.statusCode == 200){
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse['access_token'];
  }else{
    throw Exception('Failed to authenticate');
  }
}

Future fetchApi(String jwtToken) async{
  var response = await http.get(
    Uri.parse(uri)
  )
}
