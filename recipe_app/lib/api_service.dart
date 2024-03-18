import 'package:http/http.dart' as http;
import 'dart:convert';

class APIService {
  static Future getData(List<String> ingredientList) async {
    String ingredientStr = ingredientList.join(', ');

    var data = {
      'model': 'command',
      'max_tokens': 100,
      'temperature': 1,
      'return_likelihoods': 'NONE',
      'truncate': 'END',
      'prompt':
          'Create a list of recipes that can be made with the following ingredients: $ingredientStr. The recipes are:'
    };
    var response = await http.post(
      Uri.parse('https://api.cohere.ai/v1/generate'),
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
        'authorization': 'Bearer YC6ZoKABVfqfTNp8w3mZ3Rh8u5fN8OBQgwzdrVcj'
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      String result = jsonResponse['generations'][0]['text'].toString();
      return result;
    } else {
      throw Exception('Status code not 200');
    }
  }
}
