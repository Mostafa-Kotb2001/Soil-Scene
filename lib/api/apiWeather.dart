
import 'dart:async';
import 'dart:convert';
import 'package:application/model/weather.dart';
import 'package:http/http.dart' as http;

class WeatherApi {

  Future<List<Weather>> getWeatherApi(String cityName) async {
    try {
      String baseUri = 'https://api.openweathermap.org/data/2.5/weather?q=${cityName}&lang=ar&appid=9b343d5451b274be22d513bac8c0303d';
      final response = await http.get(Uri.parse(baseUri));

      if (response.statusCode == 200) {

        final responseData = json.decode(response.body);
        print('Response Data: $responseData');

        if (responseData is Map<String, dynamic>) {
          return [Weather.fromJson(responseData)];
        } else {
          throw Exception('Invalid response format. Expected a map.');
        }
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch weather data. Error: $error');
    }
  }
}
