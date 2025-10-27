
import 'package:application/api/apiWeather.dart';
import 'package:application/model/weather.dart';
import 'package:application/screen/location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/apiWeather.dart';



class WeatherController extends GetxController  {
  Locations locations = Locations();
  RxList<Weather> weather = <Weather>[].obs; // Initialize as RxList with .obs

  var isLoading = false.obs;

  WeatherApi _weatherApi = WeatherApi();

  Future<void> getWeatherApi() async {
    try {
      isLoading(true);
      await locations.updateCityName();
      weather.assignAll(await _weatherApi.getWeatherApi(locations.cityName));
    } catch (error) {
      print('Error: $error');
    } finally {
      isLoading(false);
    }
  }
}
