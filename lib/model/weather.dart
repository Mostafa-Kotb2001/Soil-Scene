class Weather {
  late Coord coord;
  late List<Weathers> weather;
  late String base;
  late Main main;
  late var visibility;
  late Wind wind;
  late Clouds clouds;
  late var dt;
  late Sys sys;
  late var timezone;
  late var id;
  late String name;
  late var cod;

  Weather({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
  });

  Weather.fromJson(Map<String, dynamic> json)
      : coord = Coord.fromJson(json['coord'] ?? {}),
        weather = (json['weather'] as List<dynamic>? ?? [])
            .map((item) => Weathers.fromJson(item as Map<String, dynamic>))
            .toList(),
        base = json['base'] ?? '',
        main = Main.fromJson(json['main'] ?? {}),
        visibility = json['visibility'] ?? 0,
        wind = Wind.fromJson(json['wind'] ?? {}),
        clouds = Clouds.fromJson(json['clouds'] ?? {}),
        dt = json['dt'] ?? 0,
        sys = Sys.fromJson(json['sys'] ?? {}),
        timezone = json['timezone'] ?? 0,
        id = json['id'] ?? 0,
        name = json['name'] ?? '',
        cod = json['cod'] ?? 0;


  Map<String, dynamic> toJson() {
    return {
      'coord': coord.toJson(),
      'weather': weather.map((e) => e.toJson()).toList(),
      'base': base,
      'main': main.toJson(),
      'visibility': visibility,
      'wind': wind.toJson(),
      'clouds': clouds.toJson(),
      'dt': dt,
      'sys': sys.toJson(),
      'timezone': timezone,
      'id': id,
      'name': name,
      'cod': cod,
    };
  }
}

class weather {
  late var id;
  late String main;
  late String description;
  late String icon;

  weather({required this.id, required this.main, required this.description, required this.icon});

  weather.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        main = json['main'] ?? '',
        description = json['description'] ?? '',
        icon = json['icon'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main': main,
      'description': description,
      'icon': icon,
    };
  }
}

class Coord {
  late var lon;
  late var lat;

  Coord({required this.lon,required this.lat});

  Coord.fromJson(Map<String, dynamic> json) {
    lon = json['lon'] ?? 0.0;
    lat = json['lat'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'lon': lon,
      'lat': lat,
    };
  }
}

class Weathers {
  late var id;
  late String main;
  late String description;
  late String icon;

  Weathers({required this.id, required this.main, required this.description, required this.icon});

  Weathers.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    main = json['main'] ?? '';
    description = json['description'] ?? '';
    icon = json['icon'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main': main,
      'description': description,
      'icon': icon,
    };
  }
}

class Main {
  late var temp;
  late var feelsLike;
  late var tempMin;
  late var tempMax;
  late var pressure;
  late var humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  Main.fromJson(Map<String, dynamic> json) {
    temp = json['temp'] ?? 0.0;
    feelsLike = json['feels_like'] ?? 0.0;
    tempMin = json['temp_min'] ?? 0.0;
    tempMax = json['temp_max'] ?? 0.0;
    pressure = json['pressure'] ?? 0;
    humidity = json['humidity'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'temp': temp,
      'feels_like': feelsLike,
      'temp_min': tempMin,
      'temp_max': tempMax,
      'pressure': pressure,
      'humidity': humidity,
    };
  }
}

class Wind {
  late var speed;
  late var deg;

  Wind({required this.speed, required this.deg});

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json['speed'] ?? 0.0;
    deg = json['deg'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'speed': speed,
      'deg': deg,
    };
  }
}

class Clouds {
  late var all;

  Clouds({required this.all});

  Clouds.fromJson(Map<String, dynamic> json) {
    all = json['all'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'all': all,
    };
  }
}

class Sys {
  late var type;
  late var id;
  late String country;
  late var sunrise;
  late var sunset;

  Sys({
    required this.type,
    required this.id,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  Sys.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? 0;
    id = json['id'] ?? 0;
    country = json['country'] ?? '';
    sunrise = json['sunrise'] ?? 0;
    sunset = json['sunset'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'country': country,
      'sunrise': sunrise,
      'sunset': sunset,
    };
  }
}
