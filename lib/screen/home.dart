import 'package:application/screen/location.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controllerWeather.dart';
import '../model/weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final WeatherController weatherController = WeatherController();

  Locations location = Locations();


  @override
  void initState() {

    location.getCityName();
    weatherController.getWeatherApi();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){
          FirebaseAuth.instance.signOut().then((value) {
            Navigator.of(context).pushNamed('/Sign in');
          });
        },
          icon: const Icon(Icons.exit_to_app , color: Colors.black,),)],
        title: Text('Home' , style: TextStyle(fontSize: 20.0 , fontWeight: FontWeight.bold,color: Colors.black),),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('background.jpeg' , fit: BoxFit.cover,)),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('UNITS')
                        .where('UserEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error in Database: ${snapshot.error}'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List<Map<String, dynamic>> dataList = snapshot.data!.docs.map((DocumentSnapshot document) {
                        return document.data() as Map<String, dynamic>;
                      }).toList();

                      return Column(
                        children: [
                          SizedBox(height: 10),
                          Center(
                            child: CarouselSlider.builder(
                              itemCount: dataList.length,
                              itemBuilder: (context, index, realIndex) {
                                if (dataList.isEmpty) {
                                  return Container(); // Return an empty container or a placeholder widget.
                                }
                                return buildCarouselItem(dataList[index]);
                              },
                              options: CarouselOptions(
                                height: 200.0,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                aspectRatio: 16 / 9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration: Duration(milliseconds: 800),
                                viewportFraction: 0.8,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Obx(() {
                    if (weatherController.isLoading.isTrue) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      final weatherData = weatherController.weather;
                      if (weatherData != null) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: weatherData.length,
                          itemBuilder: (context, index) {
                            final weather = weatherData[index];
                            double temp = weather.main.temp - 273.15;
                            String temperature = temp.toStringAsFixed(2);
                            if (weather != null && weather is Weather) {
                              return Card(
                                color: Colors.amber,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Weather Today',
                                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                        SizedBox(height: 5),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Weather: ',
                                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                            children: [TextSpan(text: weather.weather[0].main, style: TextStyle(fontSize: 16.0, color: Colors.black))],
                                          ),
                                        ),
                                        SizedBox(width: 60),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Temperature: ',
                                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                            children: [TextSpan(text: temperature, style: TextStyle(fontSize: 16.0, color: Colors.black))],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Wind: ',
                                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                            children: [TextSpan(text: weather.wind.speed.toString(), style: TextStyle(fontSize: 16.0, color: Colors.black))],
                                          ),
                                        ),
                                        SizedBox(width: 100),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Clouds: ',
                                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                            children: [TextSpan(text: weather.clouds.all.toString(), style: TextStyle(fontSize: 16.0, color: Colors.black))],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,)
                                  ],
                                ),

                              );
                            } else {
                              return Text('Error: Invalid weather data');
                            }
                          },
                        );
                      } else {
                        return Text('Error: Weather data is null');
                      }
                    }
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('UNITS')
                        .where('UserEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error in Database: ${snapshot.error}'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List<Map<String, dynamic>> dataList = snapshot.data!.docs.map((DocumentSnapshot document) {
                        return document.data() as Map<String, dynamic>;
                      }).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              for (int i = 0; i < dataList.length && i < 2; i++)
                                Container(
                                  width: 170,
                                  height: 200,
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(text: TextSpan(
                                        text: 'Temp: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Temp'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                      RichText(text: TextSpan(
                                        text: 'Humidity: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Humidity'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                      RichText(text: TextSpan(
                                        text: 'Water: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Weater'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              for (int i = 2; i < dataList.length && i < 4; i++)
                                Container(
                                  width: 180,
                                  height: 200,
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(text: TextSpan(
                                        text: 'Temp: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Temp'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                      RichText(text: TextSpan(
                                        text: 'Humidity: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Humidity'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                      RichText(text: TextSpan(
                                        text: 'Water: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Weater'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10,),

                          Row(
                            children: [
                              for (int i = 4; i < dataList.length && i < 6; i++)
                                Container(
                                  width: 180,
                                  height: 200,
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(text: TextSpan(
                                        text: 'Temp: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Temp'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                      RichText(text: TextSpan(
                                        text: 'Humidity: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Humidity'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                      RichText(text: TextSpan(
                                        text: 'Water: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Weater'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10,),

                          Row(
                            children: [
                              for (int i = 6; i < dataList.length && i < 8; i++)
                                Container(
                                  width: 180,
                                  height: 200,
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(text: TextSpan(
                                        text: 'Temp: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Temp'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                      RichText(text: TextSpan(
                                        text: 'Humidity: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Humidity'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                      RichText(text: TextSpan(
                                        text: 'Water: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Weater'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10,),

                          Row(
                            children: [
                              for (int i = 8; i < dataList.length && i < 10; i++)
                                Container(
                                  width: 180,
                                  height: 200,
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(text: TextSpan(
                                        text: 'Temp: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Temp'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                      RichText(text: TextSpan(
                                        text: 'Humidity: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Humidity'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                      RichText(text: TextSpan(
                                        text: 'Water: ',
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [TextSpan(text: dataList[i]['Weater'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
                                      )),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

        ],
      )
    );
  }
}

Widget buildCarouselItem(Map<String, dynamic> data) {
  // Customize the appearance of each carousel item
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 5.0),
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(8.0),
    ),
    padding: const EdgeInsets.all(16.0),
    child: Card(
      color: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(text: TextSpan(
            text: 'Temp: ',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
            children: [TextSpan(text: data['Temp'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
          )),
          RichText(text: TextSpan(
            text: 'Humidity: ',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
            children: [TextSpan(text: data['Humidity'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
          )),
          RichText(text: TextSpan(
            text: 'Water: ',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
            children: [TextSpan(text: data['Weater'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black))],
          )),
        ],
      ),
    ),
  );
}

