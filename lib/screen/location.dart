import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class Locations {
  late String cityName = 'Cairo'; // Default to Cairo

  Future<String> getCityName() async {
    try {
      var status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        String governorate = placemarks.isNotEmpty
            ? placemarks[0].administrativeArea ?? 'Unknown'
            : 'Unknown';

        print('kldsvnkjdsnvkjsdbvkjds$governorate');
        cityName = (await governorateToCapital[governorate])!;

        if(cityName == Null){
          return cityName ='cairo';
        }else{
          print('City name: $cityName');
          return cityName;
        }

      } else {
        // Handle denied or restricted permission
        print('Permission denied or restricted');
        return cityName; // Default to Cairo if permission denied
      }
    } catch (e) {
      print('Error getting city name: $e');
      return 'Unknown';
    }
  }

  Future<String> _getCapitalCityForGovernorate(String governorate) async {
    try {
      List<Location> locations =
      await locationFromAddress('$governorate, Egypt');
      if (locations.isNotEmpty) {
        Location location = locations[0];
        List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude, location.longitude);
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          return placemark.locality ?? 'Unknown';
        } else {
          return 'Unknown';
        }
      } else {
        throw Exception('Location not found');
      }
    } catch (e) {
      print('Error getting governorate center: $e');
      return 'Unknown';
    }
  }

  Future<void> updateCityName() async {
    cityName = await getCityName();
  }

  final Map<String, String> governorateToCapital = {
    'Cairo': 'Cairo',
    'Al-Sharqia Governorate' :'Zagazig' ,
    'Menofia Governorate' : 'minuf' ,
  };
}
